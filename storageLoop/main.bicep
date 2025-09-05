targetScope = 'subscription'

@description('the name of the resource group')
param resourceGroupName string = 'my-new-resource-grp'

@description('the locations of the resource group to be used ')
param resourceGroupLocations array = [
  'uaenorth'
  'austriaeast'
  // 'eastasia'
]

// creating the resource group
resource myResourceGroups 'Microsoft.Resources/resourceGroups@2024-11-01' = [
  for location in resourceGroupLocations: {
    name: '${resourceGroupName}-${location}'
    location: location
  }
]

// taking the resource group info in the rgInfo variable
var rgInfo = [
  for location in resourceGroupLocations: {
    name: '${resourceGroupName}-${location}'
    location: location
  }
]

//looping through the module to create the storage account per rg
module storageModule 'storage.bicep' = [
  for rg in rgInfo: {
    name: 'storageModule'
    scope: resourceGroup(rg.name)
    params: {
      storageAccountName: 'storage${uniqueString(rg.name)}'
      location: rg.location
    }
  }
]
