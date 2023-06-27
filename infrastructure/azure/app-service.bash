location="eastus"
rg="app-service-rg"
name="soft807-llanos"
plan="$name-plan"

az group create --name $rg --location $location

az appservice plan create --name $plan \
  --resource-group $rg --sku F1 --is-linux

az webapp create --resource-group $rg \
  --plan $plan --name $name --runtime "PYTHON|3.9"

cd ../..

az webapp config appsettings set --name $name--resource-group $rg \
--settings SCM_DO_BUILD_DURING_DEPLOYMENT=true

az webapp up --name $name --location $location --resource-group $rg  --plan $plan
