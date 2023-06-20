image=""
az group create --location eastus --name assignment1Diego
az vmss create \
  --resource-group assignment1Diego \
  --name assignmentVmss \
  --image $image \
  --upgrade-policy-mode automatic \
  --custom-data cloud-init.yaml \
  --admin-username azureuser \
  --generate-ssh-keys


az network lb probe create \
  --lb-name assignmentVmssLB \
  --resource-group assignment1Diego \
  --name webServerHealth \
  --port 80 \
  --protocol Http \
  --path /

az network lb rule create \
  --resource-group assignment1Diego \
  --name webServerLoadBalancerRuleWeb \
  --lb-name assignmentVmssLB \
  --probe-name webServerHealth \
  --backend-pool-name assignmentVmssLBBEPool \
  --backend-port 80 \
  --frontend-ip-name loadBalancerFrontEnd \
  --frontend-port 80 \
  --protocol tcp