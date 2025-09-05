targetScope = 'subscription'

@description('Resource Group name')
param resourceGroupName string = '<my-new-resource-grp>'

@description('Resource Group location')
param resourceGroupLocation string = 'uaenorth'

resource newRG 'Microsoft.Resources/resourceGroups@2024-11-01' = {
  name: resourceGroupName
  location: resourceGroupLocation
}
