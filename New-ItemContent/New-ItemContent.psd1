@{
    RootModule = 'New-ItemContent.psm1'
    ModuleVersion = '1.0.0.5'
    GUID = '44a086a3-36fb-48d2-90a1-eaec05bae2d5'
    Author = 'Roy Ashbrook'
    CompanyName = 'royashbrook.com'
    Copyright = '(c) 2021-2026 Roy Ashbrook. All rights reserved.'
    Description = 'Common module for generating item content for Microsoft Graph'
    PowerShellVersion = '7.0'
    FunctionsToExport = 'New-ItemContent'
    AliasesToExport = @()
    CmdletsToExport = @()
    VariablesToExport = @()
    RequiredModules = @('Add-PrefixForLogging')
    PrivateData = @{
        PSData = @{
            Tags = @('msgraph','sharepoint','sql','kpi')
            LicenseUri = 'https://github.com/royashbrook/New-ItemContent/blob/main/LICENSE'
            ProjectUri = 'https://github.com/royashbrook/New-ItemContent'
            ReleaseNotes = 'Empty-table handling is now optional. Default is unchanged (an empty table aborts the run, backwards compatible). Set allowEmpty = $true at the table, dataset, or feed (cfg) level to tolerate + emit empty tables.'
        }
    }
}
