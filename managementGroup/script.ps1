# script.ps1
# Deploy resources at management group and subscription scope using Bicep

# ===== Variables =====
$mgId = "<>"   # replace with your MG ID
$mgDeploymentName = "<>"
$mgLocation = "<>"

$subDeploymentName = "<>"
$subLocation = "<>"

# ===== Deploy to Management Group Scope =====
Write-Host "Deploying to Management Group: $mgId ..." -ForegroundColor Cyan
az deployment mg create `
  --name $mgDeploymentName `
  --location $mgLocation `
  --management-group-id $mgId `
  --template-file main.bicep

# ===== Deploy to Subscription Scope =====
Write-Host "Deploying to Subscription ..." -ForegroundColor Cyan
az deployment sub create `
  --name $subDeploymentName `
  --location $subLocation `
  --template-file testPolicy.bicep

Write-Host "Deployment completed successfully!" -ForegroundColor Green
