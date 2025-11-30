# -----------------------------------------------
# Script Name: DeleteResourceGroup.ps1
# Purpose: Delete Resource Group in Azure
# -----------------------------------------------

param(
    [Parameter(Mandatory = $true)]
    [string] $ResourceGroupName
)

Write-Host "Checking Azure Login Status..." -ForegroundColor Cyan

#Ensure the user is logged in to Azure

try {
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
    exit
}
else {
    Write-Host "Resource Group '$ResourceGroupName' exists." -ForegroundColor Cyan

    # Confirmation before deletion
    $confirmation = Read-Host "Are you sure you want to delete Resource Group '$ResourceGroupName'? This action cannot be undone. (Yes/No)"

    if ($confirmation -ne "Yes") {
        Write-Host "Deletion cancelled by user." -ForegroundColor Yellow
        exit
    }

    Write-Host "Deleting Resource Group '$ResourceGroupName'..." -ForegroundColor Cyan
    try {
        Remove-AzResourceGroup `
            -Name $ResourceGroupName `
            -Force `
            -AsJob

        Write-Host "Resource Group '$ResourceGroupName' deleted successfully." -ForegroundColor Green

    }
    catch {
        Write-Host "Failed to delete Resource Group '$ResourceGroupName'. Error: $_" -ForegroundColor Red
    }
}