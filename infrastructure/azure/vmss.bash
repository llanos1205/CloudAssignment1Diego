rg="vmss-rg"
location="eastus"
name="soft807-llanos-vmss"
az group create --location $location --name $rg

az vmss create \
  --resource-group $rg \
  --name $name \
  --image UbuntuLTS \
  --upgrade-policy-mode automatic \
  --custom-data cloud-init.yaml \
  --admin-username azureuser \
  --generate-ssh-keys

az network lb probe create \
  --lb-name "{$name}LB" \
  --resource-group $rg \
  --name webServerHealth \
  --port 80 \
  --protocol Http \
  --path /

az network lb rule create \
  --resource-group $rg \
  --name webServerLoadBalancerRuleWeb \
  --lb-name "{$name}LB" \
  --probe-name webServerHealth \
  --backend-pool-name "{$name}LBBEPool" \
  --backend-port 80 \
  --frontend-ip-name loadBalancerFrontEnd \
  --frontend-port 80 \
  --protocol tcp