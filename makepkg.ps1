$weiduApps		= @("weidu.exe", "weidu_linux")
$weiduExts		= @(".exe", "")
$weiduArchives 	= @("_win", "_linux")

$currentDir = (Get-Location).Path
$basePath = "SPC"
$tp2Name = "SPC"
$modPath = $basePath + "/" + $tp2Name 
$archive = $basePath + ".zip"
$exePath = "setup-" + $tp2Name
$folders= @(
'baf',
'bmp',
'spl',
'tra'
)

foreach($weiduArchive in $weiduArchives){
	Remove-Item -LiteralPath ($basePath + $weiduArchive + ".zip") -Force
}

Remove-Item -LiteralPath $archive -Force
Remove-Item -LiteralPath $basePath -Force -Recurse
New-Item -Name $basePath -ItemType Directory


foreach($folder in $folders){
	Copy-Item -Path $folder -Destination ($modPath + "/" + $folder) -Recurse	
}

Copy-Item -Path ($tp2Name + ".tp2") -Destination $modPath 
Copy-Item -Path "Discord Server.url" -Destination $modPath
Copy-Item -Path "PayPal.url" -Destination $modPath
Copy-Item -Path "Venmo.url" -Destination $modPath
Copy-Item -Path "release notes.md" -Destination $modPath
Copy-Item -Path "readme.md" -Destination $modPath

Get-Date -Format "yyyy-MM-dd HH:mm K" > pkgdate.txt

Copy-Item -Path pkgdate.txt -Destination $modPath

for ($i = 0; $i -lt $weiduApps.Length; $i++) {
	if($i -gt 0){
		Write-Output "Deleting " ($basePath + "/" + $exePath + $weiduExts[$i-1])
		Remove-Item -LiteralPath ($basePath + "/" + $exePath + $weiduExts[$i-1])
	}
	Copy-Item -Path $weiduApps[$i] -Destination ($basePath + "/" + $exePath + $weiduExts[$i])
	
	$archive = $basePath + $weiduArchives[$i] + ".zip"
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

	Get-FileHash $archive -Algorithm SHA256 > SHA256.txt
	Copy-Item -Path $archive -Destination ("\\nas.home.lan\smbuser\Home\Installers\" + $archive)
}

Remove-Item -LiteralPath $basePath -Force -Recurse


