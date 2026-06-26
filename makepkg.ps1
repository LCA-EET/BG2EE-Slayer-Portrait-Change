$currentDir = (Get-Location).Path
$basePath = "SPC"
$tp2Name = "SPC"
$modPath = $basePath + "/" + $tp2Name 
$archive = $basePath + ".zip"
$exePath = "setup-" + $tp2Name + ".exe"
$folders= @(
'baf',
'bmp',
'spl',
'tra'
)

Remove-Item -LiteralPath $archive -Force
Remove-Item -LiteralPath $basePath -Force -Recurse
New-Item -Name $basePath -ItemType Directory


foreach($folder in $folders){
	Copy-Item -Path $folder -Destination ($modPath + "/" + $folder) -Recurse	
}

Copy-Item -Path ($tp2Name + ".tp2") -Destination $modPath 
Copy-Item -Path "weidu.exe" -Destination ($basePath + "/" + $exePath)

Copy-Item -Path "Discord Server.url" -Destination $modPath

Get-Date -Format "yyyy-MM-dd HH:mm K" > pkgdate.txt

Copy-Item -Path pkgdate.txt -Destination $modPath
$Source = "./" + $basePath + "/*"
$Target = "./" + $archive

$7zipPath = "F:/Program Files/7-Zip/7z.exe"

if(Test-Path -Path $7zipPath){
	Set-Alias Start-SevenZip $7zipPath
	Start-SevenZip a -mx=9 $Target $Source
}
else{
	#Linux
	7z a -mx=9 $Target $Source
}

Remove-Item -LiteralPath $basePath -Force -Recurse
Get-FileHash $archive -Algorithm SHA256 > SHA256.txt

Copy-Item -Path $archive -Destination ("\\nas.home.lan\smbuser\Home\Installers\" + $archive)
