/**
this template might have some duplications for the child parent relationships */

param virtualMachines_new_vm_name string = 'new-vm'
param publicIPAddresses_new_vm_ip_name string = 'new-vm-ip'
param virtualNetworks_vnet_eastasia_name string = 'vnet-eastasia'
param networkInterfaces_new_vm822_z1_name string = 'new-vm822_z1'
param networkSecurityGroups_new_vm_nsg_name string = 'new-vm-nsg'

resource networkSecurityGroups_new_vm_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: networkSecurityGroups_new_vm_nsg_name
  location: 'eastasia'
  properties: {
    securityRules: [
      {
        name: 'SSH'
        id: networkSecurityGroups_new_vm_nsg_name_SSH.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
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
      {
        name: 'HTTPS'
        id: networkSecurityGroups_new_vm_nsg_name_HTTPS.id
        type: 'Microsoft.Network/networkSecurityGroups/securityRules'
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
    ]
  }
}

resource publicIPAddresses_new_vm_ip_name_resource 'Microsoft.Network/publicIPAddresses@2024-07-01' = {
  name: publicIPAddresses_new_vm_ip_name
  location: 'eastasia'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  zones: [
    '1'
  ]
  properties: {
    ipAddress: '20.2.211.162'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}

resource virtualNetworks_vnet_eastasia_name_resource 'Microsoft.Network/virtualNetworks@2024-07-01' = {
  name: virtualNetworks_vnet_eastasia_name
  location: 'eastasia'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'snet-eastasia-1'
        id: virtualNetworks_vnet_eastasia_name_snet_eastasia_1.id
        properties: {
          addressPrefixes: [
            '172.16.0.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualMachines_new_vm_name_resource 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: virtualMachines_new_vm_name
  location: 'eastasia'
  zones: [
    '1'
  ]
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B4as_v2'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_new_vm_name}_OsDisk_1_8d71258fef8442178df0007'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_new_vm_name}_OsDisk_1_8d71258fef8442178df0007'
          )
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_new_vm_name
      adminUsername: 'myubuntupc'
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'AutomaticByPlatform'
          automaticByPlatformSettings: {
            rebootSetting: 'IfRequired'
          }
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_new_vm822_z1_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource networkSecurityGroups_new_vm_nsg_name_HTTPS 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_new_vm_nsg_name}/HTTPS'
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
  dependsOn: [
    networkSecurityGroups_new_vm_nsg_name_resource
  ]
}

resource networkSecurityGroups_new_vm_nsg_name_SSH 'Microsoft.Network/networkSecurityGroups/securityRules@2024-07-01' = {
  name: '${networkSecurityGroups_new_vm_nsg_name}/SSH'
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
  dependsOn: [
    networkSecurityGroups_new_vm_nsg_name_resource
  ]
}

resource virtualNetworks_vnet_eastasia_name_snet_eastasia_1 'Microsoft.Network/virtualNetworks/subnets@2024-07-01' = {
  name: '${virtualNetworks_vnet_eastasia_name}/snet-eastasia-1'
  properties: {
    addressPrefixes: [
      '172.16.0.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_eastasia_name_resource
  ]
}

resource networkInterfaces_new_vm822_z1_name_resource 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: networkInterfaces_new_vm822_z1_name
  location: 'eastasia'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_new_vm822_z1_name_resource.id}/ipConfigurations/ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '172.16.0.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_new_vm_ip_name_resource.id
            properties: {
              deleteOption: 'Detach'
            }
          }
          subnet: {
            id: virtualNetworks_vnet_eastasia_name_snet_eastasia_1.id
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
      id: networkSecurityGroups_new_vm_nsg_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}
