function New-ItemContent($cfg, $file) {

    # allowEmpty (default $false) controls whether an empty table aborts the run. Read it strict-mode-safe
    # from a level, treating an absent property as $false. Precedence: table, then dataset, then feed (cfg).
    function script:Test-AllowEmpty($o) {
        [bool]($o.PSObject.Properties['allowEmpty']) -and [bool]$o.allowEmpty
    }

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
                # By default an empty table aborts the whole run, to protect feeds that must never ship a
                # dataset with a missing table. Opt out by setting allowEmpty = $true at the table, dataset,
                # or feed (cfg) level; the empty table is then emitted as an empty array.
                $allowEmpty = (Test-AllowEmpty $Table) -or (Test-AllowEmpty $DataSetConfig) -or (Test-AllowEmpty $cfg)
                if (-not $allowEmpty) {
                    l "$DataSetName.$TableName is empty. Aborting."
                    return
                }
                l "$DataSetName.$TableName is empty. allowEmpty is set, keeping it."
            }
            $Results.$DataSetName.$TableName = @($Result)
        }
    }
    $Results | ConvertTo-Json -Depth 100 | Add-Content $file             

}
Export-ModuleMember -Function New-ItemContent
