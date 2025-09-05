param location string = resourceGroup().location
param cosmosDbDatabaseName string = 'my-new-db'
param cosmosDbAccountName string = 'my-cosmosdb-account-unique1221212' // must be globally unique
param cosmosContainerName string = 'my-container'
param diagnosticSettingName string = 'my-diagnostic-setting'
param logAnalyticsWorkspaceName string = 'my-log-analytics-workspace'

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
  name: cosmosDbAccountName
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
    consistencyPolicy: {
      defaultConsistencyLevel: 'Session'
    }
    capabilities: [
      {
        name: 'EnableServerless'
      }
    ]
  }
}

resource cosmosDBdatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-04-15' = {
  parent: cosmosDbAccount
  name: cosmosDbDatabaseName
  properties: {
    resource: {
      id: 'my-new-db'
    }
  }
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2022-05-15' = {
  parent: cosmosDBdatabase
  name: cosmosContainerName
  properties: {
    resource: {
      id: 'my-container'
      partitionKey: {
        paths: [
          '/myPartitionKey'
        ]
        kind: 'Hash'
      }
    }

    options: {}
  }
}


resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
  }
}

resource diagnosticSetting 'microsoft.insights/diagnosticSettings@2016-09-01' = {
  name: diagnosticSettingName
  scope: cosmosDbAccount
  location: location
  properties: {
    workspaceId: logAnalytics.id
    logs: [
      {
        category: 'DataPlaneRequests'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
        retentionPolicy: {
          enabled: false
          days: 0
        }
      }
    ]
  }
}
