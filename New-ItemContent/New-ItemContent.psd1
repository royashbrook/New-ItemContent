@{
    RootModule = 'New-ItemContent.psm1'
    ModuleVersion = '1.0.0.6'
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
            ReleaseNotes = '1.0.0.6: fix allowEmpty emitting [null] instead of [] for an empty table (an empty result set is $null, and @($null) is a 1-element array holding $null). Also abort loudly (throw) when the config has no non-empty datasets, or a dataset has no non-empty tables, instead of silently writing an empty {} or a dataset with no tables over the live item.'
        }
    }
}
