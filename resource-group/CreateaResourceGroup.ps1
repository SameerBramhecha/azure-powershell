# -----------------------------------------------
# Script Name: resource-group.ps1
# Purpose: Create Resource Group in Azure
# -----------------------------------------------

param(
    [Parameter(Mandatory=$true)]
    [string] $ResourceGroupName,

    [Parameter(Mandatory=$true)]
    [string] $Location
)

Write-Host "Checking Azure Login Status..." -ForegroundColor Cyan

#Ensure the user is logged in to Azure

try{
    $context = Get-AzContext -ErrorAction Stop
    Write-Host "logged in to Azure as $($context.Account)." -ForegroundColor Green
}
catch {
    Write-Host "Not logged in to Azure. Please login to continue." -ForegroundColor Yellow
    Connect-AzAccount
}

Write-Host "Checking if Resource Group '$ResourceGroupName' exists..." -ForegroundColor Cyan

$rg = Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue

if ($null -eq $rg) {
    Write-Host "Resource Group '$ResourceGroupName' does not exists." -ForegroundColor Yellow

    New-AzResourceGroup `
    -Name $ResourceGroupName `
    -Location $Location `
    -Tag @{Environment="Development"; Owner="Sameer"}

    Write-Host "Resource Group '$ResourceGroupName' created successfully in location '$Location'." -ForegroundColor Green
} else{
    Write-Host "Resource Group '$ResourceGroupName' already exists in location '$($rg.Location)'." -ForegroundColor Green
}