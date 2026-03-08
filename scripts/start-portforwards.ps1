# start-portforwards.ps1
# Inicia port-forwards em background para gateway, monitoring e rabbitmq

Write-Host "Iniciando port-forwards..." -ForegroundColor Cyan

$forwards = @(
    @{ Name = "Gateway";    Args = "port-forward service/agrosense-api-gateway 8080:80 -n agrosense" },
    @{ Name = "RabbitMQ";   Args = "port-forward service/rabbitmq 15672:15672 -n agrosense" },
    @{ Name = "Grafana";    Args = "port-forward service/grafana 3000:3000 -n agrosense" },
    @{ Name = "Prometheus"; Args = "port-forward service/prometheus 9090:9090 -n agrosense" },
    @{ Name = "Loki";       Args = "port-forward service/loki 3100:3100 -n agrosense" }
)

$pids = @()

foreach ($fwd in $forwards) {
    $p = Start-Process kubectl -ArgumentList $fwd.Args -PassThru -WindowStyle Hidden
    $pids += $p.Id
    Write-Host "  [$($fwd.Name)] PID $($p.Id) -> kubectl $($fwd.Args.Split(' ')[1..2] -join ' ')" -ForegroundColor Green
}

Write-Host ""
Write-Host "Acesso local:" -ForegroundColor Yellow
Write-Host "  Gateway    -> http://localhost:8080"
Write-Host "  RabbitMQ   -> http://localhost:15672  (agrosense/agrosense)"
Write-Host "  Grafana    -> http://localhost:3000"
Write-Host "  Prometheus -> http://localhost:9090"
Write-Host "  Loki       -> http://localhost:3100"
Write-Host ""
Write-Host "PIDs ativos: $($pids -join ', ')" -ForegroundColor DarkGray
Write-Host "Para encerrar todos: $($pids | ForEach-Object { "Stop-Process -Id $_" }) " -ForegroundColor DarkGray
Write-Host "Ou rode: .\stop-portforwards.ps1" -ForegroundColor DarkGray

# Salva os PIDs para o script de stop
$pids | Out-File -FilePath "$PSScriptRoot\.pf-pids.txt"
