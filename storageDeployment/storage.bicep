@description('The SKU of the Storage Account')
param storageAccountType string = 'Standard_LRS'

@description('Location for the Storage Account')
param location string

@description('Storage Account name (must be globally unique)')
param storageAccountName string = uniqueString(resourceGroup().id)

resource storageAcct 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: storageAccountType
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

output storageAccountNameOutput string = storageAcct.name
