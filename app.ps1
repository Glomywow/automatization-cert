$PathToCfgFile = "C:\Service\RemoteApp\1C-Base\ibases_007.v8i"
#$PathToTrusted = "C:\Service\RemoteApp\TrustedSites.exe"
$PathTo1CExe = "C:\Program Files (x86)\1cv8\common\1cestart.exe"
$csp = cmd.exe /c "C:\Program Files\Crypto Pro\CSP\csptest.exe" -absorb -certs >> c:\service\test1.txt

#clear 1c cache
#$path1 ="C:\Users\" + $env:UserName + "\AppData\Local\1C\1Cv8\"
#$path2 ="C:\Users\" + $env:UserName + "\AppData\Roaming\1C\1cv8\"
#$path3 ="C:\Users\" + $env:UserName + "\AppData\Roaming\1C\1cv8\"
#Remove-Item -path $path1 -Recurse -Force
#Remove-Item -path $path2 -Recurse -Force
#Remove-Item -path $path3 -Recurse -Force	
if (!(test-path ($Env:APPDATA + '\1C\1CEStart\'))) { New-Item ($env:APPDATA + '\1C\1CEStart\') -type directory }
if (!(Test-Path ($Env:APPDATA + '\1C\1CEStart\ibases.v8i'))) { New-Item -Name ibases.v8i -Path ($Env:APPDATA + '\1C\1CEStart\') -ItemType File }
Copy-Item $PathToCfgFile ($Env:APPDATA + '\1C\1CEStart\ibases.v8i') -Force

#Start-Process -FilePath $PathToTrusted
Start-Process -FilePath $PathTo1CExe
$csp
