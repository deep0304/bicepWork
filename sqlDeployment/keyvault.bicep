param kvName string = '<your-keyvault-name> '
param kvResourceGroup string = '<resourceGroup-of-your-keyvault>'
param subscriptionId string = subscription().subscriptionId
param sqlDbName string
param serverName string
param administratorLogin string
@secure()
param administratorLoginPassword string

/**I tried to use the keyvault but using from here but it didn't work as expected.
so used by taking in the paramter with other method */
resource kv 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: kvName
  scope: resourceGroup(subscriptionId, kvResourceGroup)
}

module sqlServerModule 'sqlServer.bicep' = {
  name: 'sqlServerDeployment'
  params: {
    serverName: serverName
    sqlDbName: sqlDbName
    location: resourceGroup().location
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}
