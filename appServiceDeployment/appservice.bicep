param location string
param serverFarmId string
param websiteName string = '<your-site>' // must
param linuxFxVersion string = 'NODE|20-lts'

resource AppService 'Microsoft.Web/sites@2024-11-01' ={
  name: websiteName
  location :location
  properties: {
    serverFarmId: serverFarmId
    siteConfig:{
      linuxFxVersion:linuxFxVersion
    }
  }
}
