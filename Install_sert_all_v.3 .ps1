#USER - Указываем своего пользователя, под которым зашли
$name = "ailushnikov"
#Grop - Указываем группу офиса, куда нужно раскатать сертификат
$global:Group = "Accountants"
$objUser = New-Object System.Security.Principal.NTAccount("int.bit.ru", $name)
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$SID1 = $strSID.Value
get-childitem "HKLM:\SOFTWARE\WOW6432Node\Crypto Pro\Settings\Users\$SID1\Keys" | Remove-Item
sleep -Seconds 2
cmd /c 'C:\Program Files (x86)\Crypto Pro\CSP\csptest.exe' -keyset -enum_cont -verifycontext -fqcn -machinekeys | Out-File d:\service\name.txt
gc d:\service\name.txt | Select-String -Pattern '\\' | Out-File d:\service\key.txt
$r = gc d:\service\key.txt  
($r).Replace('\\.\FAT12_D\','') | where {$_ -ne ""} > d:\service\key.txt | Set-Content d:\service\key.txt
$keys = @(gc d:\service\key.txt)
foreach ($key in $keys) {
cmd /c "C:\Program Files (x86)\Crypto Pro\CSP\csptest.exe" -keycopy -contsrc $key  -contdest "\\.\REGISTRY\$key-copy" -silent
}
reg.exe export "HKLM\SOFTWARE\Wow6432Node\Crypto Pro\Settings\Users\$SID1\Keys" "d:\service\1.reg" /y

#Создаем папку для reg файлов 
New-Item -Path d:\Service\sbis\ -Name $Group -ItemType directory -Force
#Выгружаем учетки в фаил
$users = Get-ADGroupMember -Identity $Group | select samaccountname -ExpandProperty samaccountname | Out-File d:\service\$group.txt
#Читаем как массив
$name_users = @(gc d:\service\$group.txt)
#Копируем файл, чтобы его потом переименовать в цикле
foreach ($name_user in $name_users){
Copy-Item -Path "d:\Service\1.reg" -Destination "d:\Service\sbis\$Group\$name_user.reg" 
#Начинай новый файл переделывать уже
$key = Get-Content "d:\Service\sbis\$Group\$name_user.reg"
#используем переменную, которую создавали вверху $name_user
$objUser = New-Object System.Security.Principal.NTAccount("int.bit.ru", $name_user)
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$SID = $strSID.Value
($key).Replace("$SID1", $SID) | Set-Content "d:\Service\sbis\$Group\$name_user.reg"
}
sleep -Seconds 5
Get-childItem -path "d:\Service\sbis\$Group\" | Copy-Item -Destination "d:\Service\sbis\Cert" -Force
$users = @(Get-ChildItem d:\Service\sbis\$Group\)
$Comps = @(gc d:\service\sbis\comp.txt)
foreach ($comp in $Comps) {
foreach ($user in $users) {
cmd.exe /c "d:\service\psexec -s \\$comp  reg import import \\PC098669\Cert\$user"

}
}