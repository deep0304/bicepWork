targetScope = 'subscription'

@description('Resource Group name')
param resourceGroupName string = 'my-new-resource-grp-astasia'

@description('Resource Group location')
param resourceGroupLocation string = 'eastasia'

resource newRG 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}
@allowed([
  'production'
  'dev'
])
param env string = 'production'
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_RAGRS'
  'Standard_ZRS'
  'Premium_LRS'
  'Premium_ZRS'
])
param storageAccountType string = (env == 'dev')? 'Standard_LRS': 'Premium_ZRS'

module storageModule 'storage.bicep' = {
  name: 'storageDeployment'
  scope: newRG
  params: {
    storageAccountType: storageAccountType
    location: newRG.location
  }
}

output storageAccountNameOutput string = storageModule.outputs.storageAccountNameOutput
