function Get-pedSubgroups{
    

    <#
    .SYNOPSIS
        exports CSV report on Azure AD users and groups 
    .DESCRIPTION
        recursively displays groups and users in hierarchy organization of Azure AD
    .EXAMPLE
        Get-pedSubgroups
    #>


    cls 
 
    #Export Path 
    $exportPath = "C:\Users\Peyton.Dexter\Documents\group_export.csv"
 
    # Number of levels to output
    $levelNumber = 5
 
    IF(Test-Path -Path $exportPath){
        Remove-Item -Path $exportPath
    }
 
    
    $start = Get-AzureADGroup -All $true
    
 
    $s = "Level 1"
    for ($k = 2; $k -le $levelNumber; $k++){
        $s += ",Level $k" 
    }
 
 
    ForEach($stat in $start){
        Invoke-pedRecursion -group $stat -direction @{"Level 1" = $stat.DisplayName}
    }
}
 
 
 
function Invoke-pedRecursion {
 
    [CmdletBinding()] 
    param(
        $group
        ,
        $int = 2
        ,
        $direction = @{}
    )
 
 
    #print and add Users 
    $Users = Get-AzureADGroupMember -ObjectId $group.ObjectId | Where-Object {$_.ObjectType -eq 'user'}
    ForEach($User in $Users){
        #Print Statements 
        Write-Host "==============================================="
        Write-Output ($direction + @{"Level $int" = $user.DisplayName})
        
        #Adding objects to the CSV
        New-Object psobject -Property ($direction + @{"Level $int" = $user.DisplayName}) | Select-Object -Property ($s -split ",") | Export-Csv -Path $exportPath  -Append 
	}
 
 
    #Recursion on each group
    $childrenGroup = Get-AzureADGroupMember -ObjectId $Group.ObjectId | Where-Object {$_.ObjectType -eq 'group'}
    ForEach($childG in $childrenGroup){
 
        Invoke-pedRecursion -group $childG -int ($int + 1) -direction ($direction + @{"Level $int" = $childG.DisplayName})
    }
}

Connect-AzureAD

 
Get-pedSubgroups 


Disconnect-AzureAD