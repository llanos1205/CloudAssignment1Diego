# Set variables
rg="vmss-rg"
location="eastus"
name="soft807-llanos-vmss"
lb=$name"LB"
pool=$lb"BEPool"
sgName="my-security-group"

# Create resource group
az group create --location $location --name $rg

# Create security group with open rule
az network nsg create --resource-group $rg --name $sgName
az network nsg rule create --resource-group $rg --nsg-name $sgName --name "AllowAll" --priority 100 --source-address-prefixes "*" --destination-address-prefixes "*" --destination-port-ranges "*" --access Allow --protocol "*"

# Create VMSS with LB and security group
az vmss create \
  --resource-group $rg \
  --name $name \
  --image UbuntuLTS \
  --upgrade-policy-mode automatic \
  --admin-username azureuser \
  --generate-ssh-keys \
  --lb-sku basic \
  --nsg $sgName

echo "Creating Probe"
az network lb probe create \
  --lb-name $lb \
  --resource-group $rg \
  --name webServerHealth \
  --port 80 \
  --protocol Http \
  --path /
echo "Creating Rules"
az network lb rule create \
  --resource-group $rg \
  --name webServerLoadBalancerRuleWeb \
  --lb-name $lb \
  --probe-name webServerHealth \
  --backend-pool-name $pool \
  --backend-port 80 \
  --frontend-ip-name loadBalancerFrontEnd \
  --frontend-port 80 \
  --protocol tcp
