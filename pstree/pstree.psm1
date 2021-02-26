class TreeStruct {
    [string]$Output = ""
    [string]$Path = ""
    [int]$Depth = 1
    [bool]$isLineMode = $true
    [string[]]$TreeLine = @()
    [string]$newline = "`r`n"

    TreeStruct($Path, $Depth, $isLineMode) {
        $this.Path = $Path
        $this.Depth = $Depth
        $this.isLineMode = $isLineMode
        $this.GetAclAndChildDirRoot()
    }

    [void] GetAclAndChildDirRoot() {
    
        $this.Output += $(Split-Path -Path $this.Path -Leaf) + $this.newline
        $Children = Get-ChildItem -Path $this.Path -Force -Directory | Select-Object FullName
        for ($rootiterator = 1; $rootiterator -lt $Children.Count; $rootiterator++) {
            $this.TreeLine += "|"
            $this.GetAclAndChildDir($Children[$rootiterator - 1].FullName, $rootiterator, $rootiterator -eq $Children.Count - 1)
        }
    }
    
    [void] GetAclAndChildDir($CurrentTarget, $iterator, $isLast = $false) {
    
        if ($iterator -gt $this.Depth) {
            return;
        }
        [string]$ResText = ""
        for ($SecondIterrator = 0; $SecondIterrator -lt $iterator; $SecondIterrator++) {
            if ($this.isLineMode) {
                if ($SecondIterrator -lt $iterator - 1) {
                    # $this.TreeLine[$SecondIterrator]
                    $ResText += " "
                }
                else {
                    $ResText += "┣━"
                }
            }
            else {
                $this.Output += " "
            }
        }
        $this.Output += $(Split-Path -Leaf -Path $CurrentTarget) + $this.newline
        $children = Get-ChildItem -Path $CurrentTarget -Force -Directory | Select-Object FullName
        $iterator++
        for ($iterator2 = 1; $iterator2 -lt $children.Count; $iterator2++) {
            $this.GetAclAndChildDir($children[$iterator2 - 1].FullName, $iterator, $iterator2 -eq $children.Count - 1)
        } 
    }
}

function Get-Tree {

    Param(
        [Parameter()][String]$Path = (Convert-Path .) ,
        [Parameter()][int]$Depth = 99,
        [Parameter()][bool]$IsLineMode = $true
    ) 
    Write-Host 
    Write-Host "---------------------------------------"
    Write-Host "対象パス："$Path
    Write-Host "深さ："$Depth
    Write-Host "線モード："$IsLineMode
    Write-Host "---------------------------------------"

    [TreeStruct]$TreeObject = [TreeStruct]::New($Path, $Depth, $IsLineMode)
    Write-Host $TreeObject.Output
}
