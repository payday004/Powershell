$path = "C:\Users\chris.cox\Desktop\UserTitleManagerReport.csv"

Get-ADUser -Filter { Enabled -eq $true } -Properties Name, Manager, Department, Title, Description | Select Name, Department, Title, @{Label="ManagerName"; Expression={Get-ADUser $_.Manager | Select -ExpandProperty Name}}, Description | Export-Csv -Path $path


