$location = "eastus"
$rg = "db-rg"
$name = "soft807-llanos"
$user = "dallanos"
$pass = "LL@pass1314"

az group create --name $rg --location $location

az sql server create --name "$name-db-server" --resource-group $rg `
--location $location --admin-user $user --admin-password $pass `
--enable-public-network true --minimal-tls-version 1.2

az sql server firewall-rule create --resource-group $rg `
--server "$name-db-server" --name "AllowAllIPs" `
--start-ip-address "0.0.0.0" --end-ip-address "255.255.255.255"

az sql db create --name "$name-db-instance" --resource-group $rg `
--server "$name-db-server" --edition Basic --capacity 5