# Set variables
$rg = "vmss-rg"
$location = "eastus"
$name = "soft807-llanos-vmss"
$lb = $name + "LB"
$pool = $lb + "BEPool"
$sgName = "my-security-group"
$image = "/subscriptions/a7270d69-f072-4277-94ff-2fd1d69a69a4/resourceGroups/vmtest/providers/Microsoft.Compute/galleries/gallery/images/def1"

# Create resource group
az group create --location $location --name $rg

# Create security group with open rule
az network nsg create --resource-group $rg --name $sgName
az network nsg rule create --resource-group $rg --nsg-name $sgName --name "AllowAll" --priority 100 --source-address-prefixes "*" --destination-address-prefixes "*" --destination-port-ranges "*" --access Allow --protocol "*"

# Create VMSS with LB and security group
az vmss create `
  --resource-group $rg `
  --name $name `
  --image $image `
  --upgrade-policy-mode automatic `
  --admin-username azureuser `
  --admin-password "LL@ltair1205" `
  --security-type TrustedLaunch `
  --generate-ssh-keys `
  --lb-sku basic `
  --user-data "init.yaml" `
  --nsg $sgName `
  --instance-count 3

  #  --public-ip-per-vm `

Write-Host "Creating Probe"
az network lb probe create `
  --lb-name $lb `
  --resource-group $rg `
  --name webServerHealth `
  --port 80 `
  --protocol Http `
  --path "/"

Write-Host "Creating Rules"
az network lb rule create `
  --resource-group $rg `
  --name webServerLoadBalancerRuleWeb `
  --lb-name $lb `
  --probe-name webServerHealth `
  --backend-pool-name $pool `
  --backend-port 80 `
  --frontend-ip-name loadBalancerFrontEnd `
  --frontend-port 80 `
  --protocol tcp

