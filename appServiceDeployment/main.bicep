targetScope = 'subscription'

@description('this is the location for the storage account')
param location string = 'eastasia'


resource myEastasiaGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'eastasiagroup'
  location: location
}

module AppServicePlan 'appserviceplan.bicep' = {
  name: 'appServicePlanModule'
  scope: myEastasiaGroup
  params: {
    location: location
  }
}

module AppService 'appservice.bicep' = {
  name: 'appServiceModule'
  scope: myEastasiaGroup
  params: {
    location: location
    serverFarmId: AppServicePlan.outputs.appServicePlanId
  }
}

module storageModule 'storage.bicep' = {
  name: 'storageModule'
  scope: myEastasiaGroup
  params: {
    location: location
  }
}

output storageAccountNameOutput string = storageModule.outputs.storageName
output appServicePlanNameOutput string = AppServicePlan.outputs.appServicePlanNameOutput
output appServicePlanIdOutput string = AppServicePlan.outputs.appServicePlanId

