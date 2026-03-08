# stop-portforwards.ps1
# Encerra todos os port-forwards iniciados pelo start-portforwards.ps1

$pidsFile = "$PSScriptRoot\.pf-pids.txt"

if (Test-Path $pidsFile) {
    $pids = Get-Content $pidsFile
    foreach ($id in $pids) {
        Stop-Process -Id $id -ErrorAction SilentlyContinue
        Write-Host "Encerrado PID $id" -ForegroundColor Yellow
    }
    Remove-Item $pidsFile
    Write-Host "Todos os port-forwards encerrados." -ForegroundColor Cyan
} else {
    Write-Host "Nenhum port-forward ativo encontrado." -ForegroundColor Red
}
