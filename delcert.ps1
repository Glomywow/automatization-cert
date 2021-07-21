function Delaftercert {
$user = $env:UserName
$Name = (cmd /c 'C:\Program Files\Crypto Pro\CSP\csptest.exe' -keyset -enum_cont -verifycontext -fqcn)
$Two = ($name | Select-String -Pattern '\\' ) | Out-String
#$r = ($Two).Replace('\\.\REGISTRY\','') #| where {$_ -ne ""} 
$tree = (($Two).Replace('\\.\REGISTRY\','')) | where {$_ -ne ""} 
$For = ($tree).replace("(?m)^\s*`r`n",'').trim() | Out-File C:\tmp\$user.txt
#$keys = @($For)

$keys = @(gc C:\tmp\$user.txt)
cd 'C:\Program Files\Crypto Pro\CSP\'
ForEach ($key in $keys) {
#$certmgr= 'C:\Program Files\Crypto Pro\CSP\certmgr.exe'
$alldatacert =cmd /c certmgr.exe -list -cont $key
 $str = $alldatacert|?{$_ -match 'Not valid after|Subject|Issuer'}|convertfrom-string -Delimiter ' : ' # Отбираем Дату / Тему / Кто выпустил
  $date = [datetime]::parse(($str[2].p2 -replace 'UTC','GMT')) # Нормализуем Дату
    #$outinfo = ($subject.o -replace '"') + $(" {0:dd.MM.yyyy} " -f $date)+($issuer.o -replace '"')
    
    if($date -lt (Get-Date)) 
        {cmd /c certmgr.exe -delete -container "\\.\REGISTRY\$key" -silent}
}

}
Delaftercert
