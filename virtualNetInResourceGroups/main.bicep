targetScope = 'subscription'

param locations array = [
  'eastasia'
  'centralindia'
  'koreacentral'
]
resource myResources 'Microsoft.Resources/resourceGroups@2025-04-01' = [
  for location in locations: {
    name: 'myResourceGroup-${location}'
    location: location
  }
]
var resourceGroupInfos array = [
  for (location, i) in locations: {
    name: myResources[i].name
    location: location
  }
]

module vnetModule 'virtualNet.bicep' = [
  for (resourceGroupInfo, i) in resourceGroupInfos: {
    name: 'vnetModule-${i}'
    scope: resourceGroup(resourceGroupInfo.name)
    params: {
      location: resourceGroupInfo.location
      name: 'myVnet-${i}'
    }
  }
]
