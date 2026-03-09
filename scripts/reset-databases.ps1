$postgresPath = "C:\Users\pedro\source\repos\agrosense\agrosense-k8s\k8s\postgres"

Write-Host "Deletando recursos de postgres..." -ForegroundColor Yellow
kubectl delete -f $postgresPath --ignore-not-found

Write-Host "Aguardando pods terminarem..." -ForegroundColor Yellow
Start-Sleep -Seconds 10

Write-Host "Aplicando recursos de postgres..." -ForegroundColor Green
kubectl apply -f $postgresPath

Write-Host "Concluido!" -ForegroundColor Green