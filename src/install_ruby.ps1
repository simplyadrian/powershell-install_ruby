# Powershell 2.0

# Stop and fail script when a command fails.
$errorActionPreference = "Stop"

# load library functions
$rsLibDstDirPath = "$env:rs_sandbox_home\RightScript\lib"
. "$rsLibDstDirPath\tools\PsOutput.ps1"
. "$rsLibDstDirPath\tools\ResolveError.ps1"
. "$rsLibDstDirPath\win\Version.ps1"

try
{
    # detects if server OS is 64Bit or 32Bit 
    # Details http://msdn.microsoft.com/en-us/library/system.intptr.size.aspx
    if (Is32bit)
    {                        
        Write-Host "32 bit operating system"   
        $ruby_path = join-path C:\ "Ruby200-x64"
    } 
    else
    {                        
        Write-Host "64 bit operating system"     
        $ruby_path = join-path C:\ "Ruby200-x64"
    }

    if (test-path $ruby_path)
    {
        Write-Output "Ruby already installed. Skipping installation."
        exit 0
    }

    Write-Host "Installing Ruby to $ruby_path"

    $ruby_binary = "rubyinstaller-2.0.0-p247-x64.exe"
    cd "$env:RS_ATTACH_DIR"
    cmd /c $ruby_binary /verysilent

    #Permanently update windows Path
    if (Test-Path $ruby_path) {
        [environment]::SetEnvironmentvariable("PATH", $env:PATH+";"+$ruby_path, "Machine")
    } 
    Else 
    {
        throw "Failed to install Ruby. Aborting."
    }

}
catch
{
    ResolveError
    exit 1
}
