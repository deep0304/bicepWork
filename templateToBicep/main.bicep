param networkSecurityGroupName string = 'new-vm-nsg'
param location string = 'eastasia'
param subnetName string = 'snet-eastasia-1'
param addressPrefixSubnet string = '10.0.0.0/24'
param addressPrefixVirtualNetwork string = '10.0.0.0/16'
param virtualNetworkName string = 'vnet-eastasia'
param networkInterfaceName string = 'new-vm-nic'
param publicIPAddressName string = 'new-vm-ip'


resource newtworkSecuritygroup 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {}
}

resource sshSecurityRule 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  parent: newtworkSecuritygroup
  name: 'sshRule'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 300
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}

resource httpsRule 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  parent: newtworkSecuritygroup
  name: 'httpsRule'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '443'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 320
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  parent: virtualNetwork
  name: subnetName
  properties: {
    addressPrefixes: [
      addressPrefixSubnet
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefixVirtualNetwork
      ]
    }

    subnets: []
    enableDdosProtection: false
  }
}
resource publicIpAddress 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIPAddressName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
  ]
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'static'
    idleTimeoutInMinutes: 4
  }
}

resource networkInterface 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: networkInterfaceName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpAddress.id
            properties: {
              deleteOption: 'Detach'
            }
          }
          subnet: {
            id: subnet.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: newtworkSecuritygroup.id
    }
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}
