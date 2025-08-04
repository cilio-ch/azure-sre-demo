export TF_RG="terraform-backend-rg"
export TF_STORAGE="tfstore$RANDOM"
export TF_CONTAINER="tfstate"
export LOCATION="francecentral"

# create a resource group
az group create --name $TF_RG --location $LOCATION

# create storage account
az storage account create \
  --resource-group $TF_RG \
  --name $TF_STORAGE \
  --sku Standard_LRS \
  --encryption-services blob

# Retrieve access key to storage account
export ARM_ACCESS_KEY=$(az storage account keys list \
  --resource-group $TF_RG \
  --account-name $TF_STORAGE \
  --query '[0].value' -o tsv)

# 4. create blob container to store .tfstate
az storage container create \
  --name $TF_CONTAINER \
  --account-name $TF_STORAGE \
  --account-key $ARM_ACCESS_KEY
