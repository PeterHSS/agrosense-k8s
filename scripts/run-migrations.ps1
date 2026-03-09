# run-migrations.ps1
# Roda todas as migrations dos servicos agrosense de uma vez
$ErrorActionPreference = "Stop"

function Wait-PodReady {
    param([string]$label)
    Write-Host "Aguardando pod $label ficar pronto..." -ForegroundColor Yellow
    $timeout = 120
    $elapsed = 0
    while ($elapsed -lt $timeout) {
        $status = kubectl get pod -n agrosense -l app=$label -o jsonpath="{.items[0].status.conditions[?(@.type=='Ready')].status}" 2>$null
        if ($status -eq "True") {
            Write-Host "Pod $label pronto!" -ForegroundColor Green
            return
        }
        Start-Sleep -Seconds 3
        $elapsed += 3
    }
    throw "Timeout esperando pod $label ficar pronto."
}

Wait-PodReady "postgres-identity"
Wait-PodReady "postgres-property"
Wait-PodReady "postgres-alerts"
Wait-PodReady "postgres-sensor-ingestion"

Write-Host "Iniciando port-forwards..." -ForegroundColor Cyan
$pf1 = Start-Process kubectl -ArgumentList "port-forward service/postgres-identity 5432:5432 -n agrosense" -PassThru -WindowStyle Hidden
$pf2 = Start-Process kubectl -ArgumentList "port-forward service/postgres-property 5433:5432 -n agrosense" -PassThru -WindowStyle Hidden
$pf3 = Start-Process kubectl -ArgumentList "port-forward service/postgres-alerts 5434:5432 -n agrosense" -PassThru -WindowStyle Hidden
$pf4 = Start-Process kubectl -ArgumentList "port-forward service/postgres-sensor-ingestion 5435:5432 -n agrosense" -PassThru -WindowStyle Hidden

Write-Host "Aguardando port-forwards ficarem prontos..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

try {
    # Identity
    Write-Host "`n[1/4] Rodando migrations do Identity..." -ForegroundColor Green
    $env:ConnectionStrings__Identity = "Host=localhost;Port=5432;Database=agrosense_identity;Username=agrosense;Password=agrosense"
    Set-Location C:\Users\pedro\source\repos\agrosense\agrosense-identity
    dotnet ef database update --project Api/Api.csproj
    Write-Host "Identity OK" -ForegroundColor Green

    # Property
    Write-Host "`n[2/4] Rodando migrations do Property..." -ForegroundColor Green
    $env:ConnectionStrings__Property = "Host=localhost;Port=5433;Database=agrosense_property;Username=agrosense;Password=agrosense"
    Set-Location C:\Users\pedro\source\repos\agrosense\agrosense-property
    dotnet ef database update --project Api/Api.csproj
    Write-Host "Property OK" -ForegroundColor Green

    # Alerts
    Write-Host "`n[3/4] Rodando migrations do Alerts..." -ForegroundColor Green
    $env:ConnectionStrings__Alert = "Host=localhost;Port=5434;Database=agrosense_alerts;Username=agrosense;Password=agrosense"
    Set-Location C:\Users\pedro\source\repos\agrosense\agrosense-alert
    dotnet ef database update --project Api/Api.csproj
    Write-Host "Alerts OK" -ForegroundColor Green

    # Sensor
    Write-Host "`n[4/4] Rodando migrations do Sensor..." -ForegroundColor Green
    $env:ConnectionStrings__Sensor = "Host=localhost;Port=5435;Database=agrosense_sensor;Username=agrosense;Password=agrosense"
    Set-Location C:\Users\pedro\source\repos\agrosense\agrosense-sensor-ingestion
    dotnet ef database update --project Api/Api.csproj
    Write-Host "Sensor OK" -ForegroundColor Green

    Write-Host "`nTodas as migrations rodaram com sucesso!" -ForegroundColor Cyan
}
finally {
    Write-Host "`nEncerrando port-forwards..." -ForegroundColor Yellow
    $pf1, $pf2, $pf3, $pf4 | ForEach-Object { Stop-Process -Id $_.Id -ErrorAction SilentlyContinue }
    Write-Host "Pronto!" -ForegroundColor Cyan
}