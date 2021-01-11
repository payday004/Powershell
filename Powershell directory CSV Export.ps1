
function Get-pedSubgroups{

    <#
    .SYNOPSIS
        exports a CSV file with columns that correspond to the level of the directory 
    .PARAMETER Path
        path of specified folder
    .EXAMPLE
        Get-pedSubgroups -path C:\Users\pd_de\Desktop
    #>

    [CmdletBinding()] 
    param(
        $Path
    )

    cls

    #EDIT VARIABLES TO CUSTOMIZE 
    #destination of export CSV 
    $exportPath= "C:\Users\pd_de\Desktop\export.csv"
   
    # Number of levels to output
    $levelNumber = 7


    IF (Test-Path -Path $exportPath){
        Remove-Item -Path $exportPath
    }

    $Start = Get-Item -Path $Path| Get-ChildItem

    $s = "Level 1"
    for ($k = 2; $k -le $levelNumber; $k++){
        $s += ",Level $k"
    }

    ForEach($Stat in $Start){
        Invoke-pedRecursion -group $Stat -direction @{"Level 1" = $Stat.Name}
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

    #Printing and exporting users 
    $users = $group | Get-ChildItem | Where-Object {$_.Mode -eq '-a----'} 
    ForEach($user in $users){

        #Print Statements
        Write-output ($direction + @{"Level $int"= $user.Name}) 
        Write-output =====================================================
        
        #creating oobject and exporting to CSV
        New-Object psobject -Property ($direction + @{"Level $int" = $user.Name}) | Select-Object -Property ($s -split ",") | Export-Csv -Path $exportPath  -Append 
    }

    #Recursive call to navigate subgroups 
    $childrenGroup = $group | Get-ChildItem | Where-Object { $_.Mode -eq 'd-----'}        
    ForEach($childG in $childrenGroup){
    
         Invoke-pedRecursion -group $childG -int ($int + 1) -direction ($direction + @{"Level $int" = $childG.Name})
    }
}