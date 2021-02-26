$cpath=(Get-Location).Path+'\pstree'

Write-Host $cpath
$params = @{
    Path = $cpath
    NuGetApiKey = '????'
}
Publish-Module @params