@{
    RootModule = 'New-ItemContent.psm1'
    ModuleVersion = '1.0.0.4'
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
            ReleaseNotes = 'Align to the current feed shape: per-table .sql via Invoke-Sqlcmd, connection string from the env var named by csname, structured datasets/tables, empty-table abort. Requires PowerShell 7. Keeps Add-PrefixForLogging as a RequiredModule.'
        }
    }
}
