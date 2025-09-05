
param location string 
param storageAccountName string  // must be globally unique
resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' =  {
  name: storageAccountName
  location:location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}
