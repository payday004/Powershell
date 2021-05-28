function Get-pedSubgroups{
    
    <#
    .SYNOPSIS
        Display nested visualization of folder in console 
    .DESCRIPTION
        recursively displays folders and documents in file tree 
    .PARAMETER Path
        path of specified folder
    .EXAMPLE
        Get-pedSubgroups -path C:\Users\pd_de\Desktop> 
    #>
    
    
    
    [CmdletBinding()] 
    param(
        $Path
    )

    $start = Get-Item -Path $Path
    Invoke-pedRecursion -group $start
}


function Invoke-pedRecursion {

    [CmdletBinding()] 
    param(
        $group
        ,
        $tab = ""
    )

    $users = $group | Get-ChildItem | Where-Object {$_.Mode -eq '-a----'} 
    ForEach($user in $users){
        Write-Host ($tab) -NoNewline
        $user | Write-Host
    }

    $childrenGroup = $group | Get-ChildItem | Where-Object { $_.Mode -eq 'd-----'}        
    ForEach($childG in $childrenGroup){
            
        Write-Host ($tab) -NoNewline
        $childG | Write-Host

        Invoke-pedRecursion -group $childG -tab ($tab + "     ")
    }
}

#Get-pedSubgroups -path C:\Users\pd_de\Desktop 
