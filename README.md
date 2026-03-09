# 🌱 AgroSense K8s

Repositório de infraestrutura com todos os manifestos Kubernetes da plataforma **AgroSense**.

---

## 📋 Sobre o Projeto

Contém os manifestos e scripts para provisionamento completo do ambiente AgroSense em um cluster Kubernetes, incluindo os microsserviços, banco de dados, mensageria e stack de monitoramento.

---

## 🏗️ Serviços no Cluster

| Serviço | Tipo | Porta |
|---|---|---|
| `agrosense-api-gateway` | NodePort | `30080` |
| `agrosense-api-identity` | ClusterIP | `80` |
| `agrosense-api-alert` | ClusterIP | `80` |
| `agrosense-api-property` | ClusterIP | `80` |
| `agrosense-api-sensor` | ClusterIP | `80` |
| `postgres-identity` | ClusterIP | `5432` |
| `postgres-alerts` | ClusterIP | `5432` |
| `postgres-property` | ClusterIP | `5432` |
| `postgres-sensor-ingestion` | ClusterIP | `5432` |
| `rabbitmq` | ClusterIP | `5672 / 15672` |
| `prometheus` | NodePort | `30090` |
| `grafana` | ClusterIP | `3000` |
| `loki` | ClusterIP | `3100` |

---

## 📁 Estrutura do Repositório

```
agrosense-k8s/
├── k8s/
│   ├── kustomization.yaml
│   ├── applications/       # Manifestos dos microsserviços AgroSense
│   ├── base/
│   │   └── namespace.yaml  # Namespace agrosense
│   ├── monitoring/
│   │   ├── prometheus.yaml
│   │   ├── grafana.yaml
│   │   └── loki.yaml
│   ├── postgres/
│   │   ├── postgres-identity.yaml
│   │   ├── postgres-property.yaml
│   │   ├── postgres-sensor-ingestion.yaml
│   │   └── postgres-alerts.yaml
│   └── rabbitmq/
│       └── rabbitmq.yaml
└── scripts/                # Scripts utilitários para o cluster
```

---

## 🚀 Deploy

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

# Mensageria
kubectl apply -f k8s/rabbitmq/

# Monitoramento
kubectl apply -f k8s/monitoring/

# Microsserviços
kubectl apply -f k8s/applications/
```

### Verificar o ambiente

```bash
kubectl get services -n agrosense
kubectl get pods -n agrosense
```

---

## 🔌 Acessar Serviços Externamente

Os serviços estão como `ClusterIP` por padrão (acesso interno ao cluster). Para expor durante o desenvolvimento, use port-forward:

```bash
# Grafana
kubectl port-forward svc/grafana 3000:3000 -n agrosense

# RabbitMQ Management
kubectl port-forward svc/rabbitmq 15672:15672 -n agrosense
```

Ou altere o `type` do Service para `NodePort` ou `LoadBalancer` conforme necessário.

---

## 📊 Observabilidade

Após o deploy, configure os datasources no Grafana:

| Fonte | URL interna |
|---|---|
| Prometheus | `http://prometheus:9090` |
| Loki | `http://loki:3100` |

---

## ⚠️ Notas Importantes

- **Secrets**: As senhas estão em texto plano nos manifests. Em produção, use ferramentas como [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets), [External Secrets Operator](https://external-secrets.io/) ou o vault do seu cloud provider.
- **Prometheus config**: O ConfigMap em `prometheus.yaml` contém uma configuração mínima. Substitua pelo conteúdo do seu `prometheus.yml` local conforme necessário.
- **Storage**: Os PVCs usam `storageClassName` padrão do cluster. Ajuste conforme o seu provider (ex: `gp2` na AWS, `standard` no GKE).

---

## 📄 Licença

Este projeto está licenciado sob a licença **MIT**. Consulte o arquivo [LICENSE](./LICENSE) para mais detalhes.
