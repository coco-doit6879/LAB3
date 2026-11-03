$ErrorActionPreference = 'Stop'
$taskCli = Join-Path $PSScriptRoot '..\..\tools\firebase-cli\node_modules\.bin\firebase.cmd'
Write-Host 'Firebase project: deadline-mate-feff4'
Write-Host 'Dang nhap bang tai khoan Google da tao Deadline Mate.'
Write-Host 'Neu CLI hien URL, mo URL va nhap ma xac nhan truc tiep trong Terminal. Khong gui ma qua chat.'
& $taskCli login
Write-Host ''
Write-Host 'Neu nhan duoc authorization code, chay tai Terminal nay:'
Write-Host ('& "' + (Resolve-Path $taskCli).Path + '" login <authorizationCode>')
Write-Host 'Sau khi dang nhap thanh cong, bao lai trong chat. Khong gui authorizationCode.'
