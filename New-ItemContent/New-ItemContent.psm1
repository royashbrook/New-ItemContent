function New-ItemContent($cfg, $file) {

    # allowEmpty (default $false) controls whether an empty table aborts the run. Read it strict-mode-safe
    # from a level, treating an absent property as $false. Precedence: table, then dataset, then feed (cfg).
    function script:Test-AllowEmpty($o) {
        [bool]($o.PSObject.Properties['allowEmpty']) -and [bool]$o.allowEmpty
    }

    $Results = @{}
    # a shape-broken but valid-JSON config (missing/typo'd 'datasets') would otherwise fall straight
    # through to an empty {} upload over the live item. fail loud instead. strict-mode-safe read.
    if (-not ($cfg.PSObject.Properties['datasets'] -and $cfg.datasets)) {
        throw "config has no non-empty 'datasets'. Refusing to write an empty object over the live item."
    }
    foreach ($DataSetConfig in $cfg.datasets) {
        $DataSetName = $DataSetConfig.name
        l "Processing Dataset: $DataSetName"
        $Results.$DataSetName = @{}
        $Results.$DataSetName.tds = Get-Date -Format "o"
        # same guard one level down: a dataset with no tables would ship {tds:...} and nothing else.
        if (-not ($DataSetConfig.PSObject.Properties['tables'] -and $DataSetConfig.tables)) {
            throw "Dataset '$DataSetName' has no non-empty 'tables'. Refusing to write an empty dataset."
        }
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
            # an empty result set is $null; a bare @($Result) then serializes as [null] (a 1-element array
            # holding $null, a phantom row that breaks consumers). filter the null so empty => [] while any
            # real row set is unchanged. keep this DIRECT: wrapping it in an if/else would unroll a single-
            # row array back to a bare object and break the [{...}] contract.
            $Results.$DataSetName.$TableName = @($Result | Where-Object { $null -ne $_ })
        }
    }
    $Results | ConvertTo-Json -Depth 100 | Add-Content $file             

}
Export-ModuleMember -Function New-ItemContent
