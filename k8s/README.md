# AgroSense — Kubernetes Manifests

## Estrutura

```
k8s/
├── kustomization.yaml
├── base/
│   └── namespace.yaml
├── postgres/
│   ├── postgres-identity.yaml
│   ├── postgres-property.yaml
│   ├── postgres-sensor-ingestion.yaml
│   └── postgres-alerts.yaml
├── monitoring/
│   ├── loki.yaml
│   ├── prometheus.yaml
│   └── grafana.yaml
└── rabbitmq/
    └── rabbitmq.yaml
```

## Deploy

### Tudo de uma vez (via Kustomize)
```bash
kubectl apply -k k8s/
```

### Por módulo
```bash
# Namespace primeiro
kubectl apply -f k8s/base/namespace.yaml

# Bancos de dados
kubectl apply -f k8s/postgres/

# Monitoring
kubectl apply -f k8s/monitoring/

# RabbitMQ
kubectl apply -f k8s/rabbitmq/
```

## Acessar serviços externamente

Os Services estão como `ClusterIP` por padrão (acesso interno ao cluster).
Para expor externamente, use port-forward durante desenvolvimento:

```bash
# Exemplo: acessar Grafana
kubectl port-forward svc/grafana 3000:3000 -n agrosense

# Exemplo: acessar RabbitMQ Management
kubectl port-forward svc/rabbitmq 15672:15672 -n agrosense
```

Ou altere o `type` do Service para `NodePort` ou `LoadBalancer` conforme necessário.

## Notas importantes

- **Secrets**: As senhas estão em texto plano nos manifests. Em produção, use
  ferramentas como [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets),
  [External Secrets Operator](https://external-secrets.io/), ou o vault do seu cloud provider.

- **Prometheus config**: O ConfigMap em `prometheus.yaml` contém uma configuração
  mínima. Substitua pelo conteúdo do seu `prometheus/prometheus.yml` local.

- **Storage**: Os PVCs usam `storageClassName` padrão do cluster. Ajuste conforme
  o seu provider (ex: `gp2` na AWS, `standard` no GKE).
