param serverName string


param sqlDbName string


param location string


param administratorLogin string


@secure()
param administratorLoginPassword string






resource sqlServer 'Microsoft.Sql/servers@2023-08-01' = {
  name: serverName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    version: '12.0'
  }
}
resource sqlDb 'Microsoft.Sql/servers/databases@2023-08-01' = {
  parent: sqlServer
  name: sqlDbName
  location: location
  sku: { name: 'Standard', tier: 'Standard' }
}
