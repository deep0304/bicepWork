param location string = resourceGroup().location

var virtualNetworkName = 'my-vnet'

param subnets array = [
  {
    name: 'subnet-1'
    addressPrefix: '10.0.0.0/24'
  }
  {
    name: 'subnet-2'

    addressPrefix: '10.0.1.0/24'
  }
]

var subnetProperty = [
  for subnet in subnets: {
    name: subnet.name
    properties: {
      addressPrefix: subnet.addressPrefix
    }
  }
]
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: subnetProperty
  }
}
