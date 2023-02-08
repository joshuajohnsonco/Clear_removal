#Powershell script written to remediate Clear.exe malware. Joshua Johnson 2/6/23

New-Item -Path 'C:\temp' -ItemType Directory -Force
Start-Transcript -Path "c:\temp\Clear_remover.txt"

#Kills the process if running:
Get-Process -Name clear -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process -Name clearbar -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process -Name clearbrowser -ErrorAction SilentlyContinue | Stop-Process -Force

#Checks each user folder and removes Clear instance from \appdata\local\programs\ and the downloads folder.
$UserFolders = get-childitem -Force -Directory -path "c:\users" | select-object name
foreach ($UserFolder in $UserFolders)
{
	$user = $UserFolder."Name";
	$path = "c:\users\$user";
	foreach ( $file in 
				'\Desktop\Clear.lnk',
				'\Desktop\Clear.lnk',
				'\downloads\Clear*.exe',
				'\AppData\Local\Clear\*',
				'\AppData\Local\ClearBar\*',
				'\downloads\Wave*Browser*.exe',
				'\AppData\Local\ClearBrowser\*',
				'\downloads\ManualsLibrary*.exe',
				'\appdata\local\programs\clear\*',
				'\appdata\local\programs\ClearBar\*',
				'\appdata\roaming\microsoft\windows\Start Menu\Programs\Clear.lnk',
				'\appdata\roaming\microsoft\windows\Start Menu\Programs\ClearBar.lnk'					
	        ) {
	            Remove-Item -path $path$file -ErrorAction Ignore -Recurse -Verbose
		#Write-Host Full path: $path$file;
	}
}

#Deletes the scheduled tasks.
Remove-Item -path "C:\Windows\Prefetch\Clear*.pf" -ErrorAction Ignore -Recurse -Verbose
Remove-Item -path "C:\windows\system32\tasks\ClearUpdateChecker" -ErrorAction Ignore -Recurse -Verbose
Remove-Item -path "C:\windows\system32\tasks\ClearbarUpdateChecker" -ErrorAction Ignore -Recurse -Verbose
Remove-Item -path "C:\windows\system32\tasks\ClearStartAtLoginTask" -ErrorAction Ignore -Recurse -Verbose
Remove-Item -path "C:\windows\system32\tasks\ClearbarStartAtLoginTask" -ErrorAction Ignore -Recurse -Verbose

Stop-Transcript
