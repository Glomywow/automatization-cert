#Grop - Указываем группу офиса, куда нужно раскатать сертификат
$Group = "Список сотрудников офиса Воронеж"

#Создаем папку для reg файлов 
New-Item -Path C:\Service\sbis\ -Name $Group -ItemType directory -Force
#Выгружаем учетки в фаил
$users = Get-ADGroupMember -Identity $Group | select samaccountname -ExpandProperty samaccountname | Out-File C:\service\$group.txt
#Читаем как массив
$name_users = @(gc C:\service\$group.txt)
#Копируем файл, чтобы его потом переименовать в цикле
foreach ($name_user in $name_users){
Copy-Item -Path "C:\Service\sbis\temp.reg" -Destination "C:\Service\sbis\$Group\$name_user.reg" 
#Начинай новый файл переделывать уже
$key = Get-Content "C:\Service\sbis\$Group\$name_user.reg"
#используем переменную, которую создавали вверху $name_user
$objUser = New-Object System.Security.Principal.NTAccount("int.bit.ru", $name_user)
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$SID = $strSID.Value
($key).Replace("S-1-5-21-2562163532-2550886452-409202375-61339", $SID) | Set-Content "C:\Service\sbis\$Group\$name_user.reg"
}
sleep -Seconds 5
Get-childItem -path "C:\Service\sbis\$Group\" | Copy-Item -Destination "C:\Service\sbis\Cert" -Force
$users = @(Get-ChildItem C:\Service\sbis\Cert\)
$Comps = @(gc c:\service\sbis\srv.txt)
foreach ($comp in $Comps) {
foreach ($user in $users) {
cmd.exe /c "c:\service\psexec -s \\$comp  reg import \\srv-udc-rdsh-13\sbis\Cert\$user"

}
}