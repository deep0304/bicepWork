param sku string = 'F1'
param location string


resource AppServicePlan 'Microsoft.Web/serverfarms@2024-11-01'={
  name: 'myAppServicePlan'
  location: location
  sku: {
    name: sku
    tier: 'Free'
  }
  properties: {
    reserved: true
  }
}

output appServicePlanNameOutput string = AppServicePlan.name
output appServicePlanId string = AppServicePlan.id
