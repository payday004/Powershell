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
    $exportPath = C:\Users\Peyton.Dexter\Desktop\export.csv
 
    # Number of levels to output
    $levelNumber = 5
 
    IF(Test-Path -Path $exportPath){
        Remove-Item -Path $exportPath
    }
 
    
    $start = Get-ADGroup -Filter 'groupcategory -eq "distribution"'
    
 
    $s = "Level 1"
    for ($k = 2; $k -le $levelNumber; $k++){
        $s += ",Level $k" 
    }
 
 
    ForEach($stat in $start){
        Invoke-pedRecursion -group $stat -direction @{"Level 1" = $stat.Name}
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
    $Users = Get-ADGroupMember -Identity $group.name | Where-Object {$_.ObjectClass -eq 'user'}
    ForEach($User in $Users){
        #Print Statements 
        Write-Host "==============================================="
        Write-Output ($direction + @{"Level $int" = $user.Name})
        
        #Adding objects to the CSV
        New-Object psobject -Property ($direction + @{"Level $int" = $user.Name}) | Select-Object -Property ($s -split ",") | Export-Csv -Path $exportPath  -Append 
	}
 
 
    #Recursion on each group
    $childrenGroup = Get-ADGroupMember -Identity $Group.name | Where-Object {$_.ObjectClass -eq 'group'}
    ForEach($childG in $childrenGroup){
 
        Invoke-pedRecursion -group $childG -int ($int + 1) -direction ($direction + @{"Level $int" = $childG.Name})
    }
}
 
#Get-pedSubgroups 

