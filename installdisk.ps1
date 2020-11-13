$sid = "S-1-5-21-2562163532-2550886452-409202375-61339"
get-childitem "HKLM:\SOFTWARE\WOW6432Node\Crypto Pro\Settings\Users\$sid\Keys" | Remove-Item
sleep -Seconds 2
cmd /c 'C:\Program Files (x86)\Crypto Pro\CSP\csptest.exe' -keyset -enum_cont -verifycontext -fqcn -machinekeys | Out-File C:\service\name.txt
gc C:\service\name.txt | Select-String -Pattern '\\' | Out-File C:\service\key.txt
$r = gc C:\service\key.txt  
($r).Replace('\\.\FAT12_E\','') | where {$_ -ne ""} > c:\service\key.txt | Set-Content c:\service\key.txt
$keys = @(gc c:\service\key.txt)
foreach ($key in $keys) {
cmd /c "C:\Program Files (x86)\Crypto Pro\CSP\csptest.exe" -keycopy -contsrc $key  -contdest "\\.\REGISTRY\$key-copy" -silent
}
reg.exe export "HKLM\SOFTWARE\Wow6432Node\Crypto Pro\Settings\Users\$sid\Keys" "C:\service\temp.reg" /y
