location="eastus"
rg="app-service-rg"
name="soft807-llanos"
plan="$name-plan"
echo "Creating RG"
az group create --name $rg --location $location
echo "Creating Plan"
az appservice plan create --name $plan \
  --resource-group $rg --sku F1 --is-linux
echo "Creating WebApp"
az webapp create --resource-group $rg \
  --plan $plan --name $name --runtime "PYTHON|3.10"
cd ../..
echo "Setting rules"
az webapp config appsettings set --name $name --resource-group $rg \
  --settings ENABLE_ORYX_BUILD=true
echo "Updating code"
az webapp up --name $name --location $location --resource-group $rg --plan $plan
