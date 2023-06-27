location="eastus"
rg="app-service-rg"
name="soft807-llanos"
plan="$name-plan"
az group create --name <resource-group-name> --location <region>
az sql server create --name <server-name> --resource-group <resource-group-name> \
--location <region> --admin-user <admin-username> --admin-password <admin-password> \
 --enable-public-network false --minimal-tls-version 1.2
az sql db create --name <database-name> --resource-group <resource-group-name> \
--server <server-name> --edition Basic --family Gen4 --capacity 1
