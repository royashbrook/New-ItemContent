function New-ItemContent($cfg, $file) {

    $Results = @{}
    foreach ($DataSetConfig in $cfg.datasets) {
        $DataSetName = $DataSetConfig.name
        l "Processing Dataset: $DataSetName"
        $Results.$DataSetName = @{}
        $Results.$DataSetName.tds = Get-Date -Format "o"
        foreach ($Table in $DataSetConfig.tables) {
            $Result = $null
            $TableName = $Table.name
            l "Processing Dataset.Table: $DataSetName.$TableName"
            $Result = Invoke-Sqlcmd -QueryTimeout 1800 `
                -ConnectionString (
                    [Environment]::GetEnvironmentVariable($DataSetConfig.csname, [EnvironmentVariableTarget]::Process) `
                    ?? (throw "Environment variable '$($DataSetConfig.csname)' not found.")
                ) `
                -InputFile $Table.sql |
                Select-Object * -ExcludeProperty ItemArray, Table, RowError, RowState, HasErrors

            if (($Result | Measure-Object).count -eq 0) {
                l "$DataSetName.$TableName is empty. Aborting."
                return
            }
            $Results.$DataSetName.$TableName = @($Result)
        }
    }
    $Results | ConvertTo-Json -Depth 100 | Add-Content $file             

}
Export-ModuleMember -Function New-ItemContent