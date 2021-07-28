$PathToCfgFile = "C:\Service\RemoteApp\1C-Base\ibases_032.v8i"
#$PathToTrusted = "C:\Service\RemoteApp\TrustedSites.exe"
$PathTo1CExe = "C:\Program Files (x86)\1cv8\common\1cestart.exe"

function Delaftercert {
$user = $env:UserName
$Name = (cmd /c 'C:\Program Files\Crypto Pro\CSP\csptest.exe' -keyset -enum_cont -verifycontext -fqcn)
$Two = ($name | Select-String -Pattern '\\' ) | Out-String
$r = ($Two).Replace('\\.\REGISTRY\','') #| where {$_ -ne ""} 
$tree = (($Two).Replace('\\.\REGISTRY\','')) | where {$_ -ne ""} 
$For = ($tree).replace("(?m)^\s*`r`n",'').trim() | Out-File C:\users\$user\Documents\$user.txt
$keys = @($For)

$keys = @(gc C:\users\$user\Documents\$user.txt)
cd 'C:\Program Files\Crypto Pro\CSP\'
ForEach ($key in $keys) {
$certmgr= 'C:\Program Files\Crypto Pro\CSP\certmgr.exe'
$alldatacert =cmd /c certmgr.exe -list -cont $key
 $str = $alldatacert|?{$_ -match 'Not valid after|Subject|Issuer'}|convertfrom-string -Delimiter ' : ' # Отбираем Дату / Тему / Кто выпустил
  $date = [datetime]::parse(($str[2].p2 -replace 'UTC','GMT')) # Нормализуем Дату
    $outinfo = ($subject.o -replace '"') + $(" {0:dd.MM.yyyy} " -f $date)+($issuer.o -replace '"')
    
    if($date -lt (Get-Date)) 
        {cmd /c certmgr.exe -delete -container "\\.\REGISTRY\$key" >> C:\users\$user\Documents\$user.log}
}

}
if (!(test-path ($Env:APPDATA + '\1C\1CEStart\'))) { New-Item ($env:APPDATA + '\1C\1CEStart\') -type directory }
if (!(Test-Path ($Env:APPDATA + '\1C\1CEStart\ibases.v8i'))) { New-Item -Name ibases.v8i -Path ($Env:APPDATA + '\1C\1CEStart\') -ItemType File }
Copy-Item $PathToCfgFile ($Env:APPDATA + '\1C\1CEStart\ibases.v8i') -Force
Delaftercert
#Start-Process -FilePath $PathToTrusted
Start-Process -FilePath $PathTo1CExe
