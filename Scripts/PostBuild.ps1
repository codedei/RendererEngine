# MIT License

# Copyright (c) 2020 Jean Philippe

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

#Requires -PSEdition Core

param (
    [Parameter(HelpMessage="System name to build, default to all")]
    [ValidateSet('Windows', 'Linux')]
    [string[]] $SystemNames = @('Windows', 'Linux'),

    [Parameter(HelpMessage="Configuration type to build, default to Debug")]
    [ValidateSet('Debug', 'Release')]
    [string[]] $Configurations = 'Debug'
)

$ErrorActionPreference = "Stop"
[string]$RepoRoot = [IO.Path]::Combine($PSScriptRoot, "..")
[string]$OuputBuildDirectory = [IO.Path]::Combine($RepoRoot, "out\build")

$ContentsToProcess = @(
    @{
        Name = "Resources"
        IsDirectory = $true
        Contents = @(
            if ($SystemNames -eq "Windows"){
                @{ From = "$RepoRoot\Resources";    To = "$OuputBuildDirectory\Examples\Sandbox\src\$Configurations\"}
                @{ From = "$RepoRoot\Resources";    To = "$OuputBuildDirectory\Examples\Sandbox3D\src\$Configurations\"}
            }
            else {
                @{ From = "$RepoRoot\Resources";    To = "$OuputBuildDirectory\Examples\Sandbox\src\"}
                @{ From = "$RepoRoot\Resources";    To = "$OuputBuildDirectory\Examples\Sandbox3D\src\"}
            }
        )
    }
    @{
        Name = "Assets"
        IsDirectory = $true
        Contents = @(
            if ($SystemNames -eq "Windows") {
                @{ From = "$RepoRoot\Assets";   To = "$OuputBuildDirectory\Examples\Sandbox\src\$Configurations\"}
                @{ From = "$RepoRoot\Assets";   To = "$OuputBuildDirectory\Examples\Sandbox3D\src\$Configurations\"}
            }
            else {
                @{ From = "$RepoRoot\Assets";   To = "$OuputBuildDirectory\Examples\Sandbox\src\"}
                @{ From = "$RepoRoot\Assets";   To = "$OuputBuildDirectory\Examples\Sandbox3D\src\"}
            }
        )
    }
)

foreach ($item in $ContentsToProcess) {
    foreach($content in $item.Contents) {
        if($item.IsDirectory -eq $true) {
            Copy-Item -Path $content.From -Destination $content.To -Recurse -Force
        }
        else {
            Copy-Item -Path $content.From -Destination $content.To -Force
        }
    }
    $name = $item.Name
    Write-Host "Copied $name"
}