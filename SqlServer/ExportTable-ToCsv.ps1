<#
    .NAME 
    ExportTable-ToCsv.ps1
    
    .SYNOPSIS
    Save sql server table as CSV.

    .DESCRIPTION
    This script is used for exporting sql server table data into a flat-file (CSV) format.
#>

[CmdletBinding()]

Param (
    [Parameter(Mandatory=$True)]
    [String[]]$Table,
    [Parameter(Mandatory=$True)]
    [String]$Server,
    [Parameter(Mandatory=$True)]
    [String]$Username,
    [Parameter(Mandatory=$True)]
    [String]$Password,
    [Parameter(Mandatory=$True)]
    [String]$Database,
    [Parameter(Mandatory=$True)]
    [String]$Path,
    [Parameter(Mandatory=$True)]
    [String]$Delimiter
)

Import-Module SqlServer

$QueryToExecute = "SELECT * FROM {0}"

If ($Table.Length -gt 1) {
    ForEach ($T in $Table) { 
        Invoke-Sqlcmd -ServerInstance $Server -Username $Username -Password $Password -Database $Database -TrustServerCertificate -Query "SELECT * FROM $T" `
            | Export-Csv -Path $Path -Delimiter $Delimiter -NoTypeInformation
    }
} Else { 
    Invoke-Sqlcmd -ServerInstance $Server -Username $Username -Password $Password -Database $Database -TrustServerCertificate -Query "SELECT * FROM $Table" `
        | Export-Csv -Path "$Path" -Delimiter $Delimiter -NoTypeInformation
}

