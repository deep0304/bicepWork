param location string
param name string
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-05-01' = {
  name: name
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
