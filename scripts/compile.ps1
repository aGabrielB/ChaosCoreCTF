# Removing any existing corectf files.
$files = Get-ChildItem "."
for ($i = 0; $i -lt $files.Count; $i++) 
{
    if ($files[$i].FullName.Contains("corectf-r")) 
    {
        Remove-Item $files[$i].FullName
    }
}

$revisionNumber = git rev-list --count HEAD
$filenameBase = "corectf-r" + $revisionNumber
$zipName = $filenameBase + ".zip"
$pk3Name = $filenameBase + ".pk3"

# This only works when the extension is .zip... not sure why they added such a
# requirement.
Write-Output "Compiling corectf pk3, this may take 10-20 seconds..."
Compress-Archive -Path "pk3\*" -CompressionLevel Optimal -DestinationPath $zipName
if(![System.IO.File]::Exists($zipName))
{
    Write-Output "Unable to zip up directory"
    [Environment]::Exit(1)
}

Rename-Item $zipName $pk3Name
if([System.IO.File]::Exists($pk3Name))
{
    Write-Output "Finished compilation!"
}
else
{
    Write-Output "Compilation failed to rename the .zip to a .pk3"
    [Environment]::Exit(1)
}
