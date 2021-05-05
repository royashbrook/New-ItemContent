function New-ItemContent($cfg, $file, $type = "sql") {
    #we already have more types in other jobs
    # those will be consolidated here as well
    switch ($type) {
        "sql" { New-ItemContentWithSql $cfg, $sql; break;}
        # "sql" { New-ItemContentWithSql $cfg, $sql; break;}
        default {
            "Nothing generated"
         }
    }
}
function New-ItemContentWithSql($cfg, $file) {
    $rv = @{}
    $rv.add("tds", (Get-Date -Format "o"))
    $tc = 0 # table counter

    foreach ($dscfg in $cfg.datasets) {
    
        l ("Processing DataSet {0}" -f $dscfg.name)
        $tablenames = $dscfg.tablenames -split ","
        $ds = (Get-DataSetFromSQL (Get-Content $dscfg.sql -Raw) $cfg.cs.($dscfg.csname))
        $qryresults = @{}
        for ($i = 0; $i -lt $ds.Tables.Count; $i++) {
            $table = $ds.Tables[$i]
            l "Adding table $tc"
            $r = New-Object System.Collections.Generic.List[System.Object]
            $table.Rows | Select-Object $table.Columns.ColumnName | ForEach-Object { $r.Add($_) }
            $qryresults.add($tablenames[$i], $r)
            $tc++
        }
        $qryresults.add("tds", (Get-Date -Format "o"))
        $rv.add("$($dscfg.name)", $qryresults)

    }

    if ($tc -ne 0) {
        $rv | ConvertTo-Json -Depth 20 | add-content $file
    }
    else {
        l "No Data Found"
    }
}
Export-ModuleMember -Function New-ItemContent