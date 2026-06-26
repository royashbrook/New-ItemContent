@{
    RootModule = 'New-ItemContent.psm1'
    ModuleVersion = '1.0.0.3'
    GUID = '44a086a3-36fb-48d2-90a1-eaec05bae2d5'
    Author = 'Roy Ashbrook'
    CompanyName = 'royashbrook.com'
    Copyright = '(c) 2021-2026 Roy Ashbrook. All rights reserved.'
    Description = 'Common module for generating item content for Microsoft Graph'
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
            ReleaseNotes = 'Declare Add-PrefixForLogging as a RequiredModule; CompanyName -> royashbrook.com; add MIT license + project metadata.'
        }
    }
}
