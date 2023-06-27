location="eastus"
rg="db-rg"
name="soft807-llanos"
user="dallanos"
pass="pass1314"
az group create --name $rg --location $location
az sql server create --name "$name-db-server" --resource-group $rg \
--location $location --admin-user $user --admin-password $pass \
 --enable-public-network true --minimal-tls-version 1.2


az sql db create --name "$name-db-instance" --resource-group $rg \
--server "$name-db-server" --edition Basic --family Gen4 --capacity 1
