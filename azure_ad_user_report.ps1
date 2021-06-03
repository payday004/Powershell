$path = "./azure_user_export.csv"

Connect-AzureAD

Get-AzureADUser -All $true | select DisplayName, Department, JobTitle, @{Label="ManagerName"; Expression={Get-AzureADUserManager -ObjectId $_.ObjectId | select -ExpandProperty DisplayName}} | Export-Csv -Path $path 

Disconnect-AzureAD


