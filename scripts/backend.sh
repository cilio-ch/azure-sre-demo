# 📌 Tu peux modifier ces variables si tu veux
export TF_RG="terraform-backend-rg"
export TF_STORAGE="tfstore$RANDOM"
export TF_CONTAINER="tfstate"
export LOCATION="francecentral"

# 1. Crée le Resource Group
az group create --name $TF_RG --location $LOCATION

# 2. Crée le Storage Account (nom unique requis)
az storage account create \
  --resource-group $TF_RG \
  --name $TF_STORAGE \
  --sku Standard_LRS \
  --encryption-services blob

# 3. Récupère la clé d’accès au compte de stockage
export ARM_ACCESS_KEY=$(az storage account keys list \
  --resource-group $TF_RG \
  --account-name $TF_STORAGE \
  --query '[0].value' -o tsv)

# 4. Crée le container blob pour stocker le .tfstate
az storage container create \
  --name $TF_CONTAINER \
  --account-name $TF_STORAGE \
  --account-key $ARM_ACCESS_KEY
