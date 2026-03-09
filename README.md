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

## 🚀 Deploy

```bash
# Aplicar todos os manifestos
kubectl apply -k k8s/ 

# Verificar os serviços
kubectl get services -n agrosense

# Verificar os pods
kubectl get pods -n agrosense
```

---

## 📊 Observabilidade

Após o deploy, configure os datasources no Grafana:

| Fonte | URL interna |
|---|---|
| Prometheus | `http://prometheus:9090` |
| Loki | `http://loki:3100` |

---

## 📁 Estrutura do Repositório

```
agrosense-k8s/
├── k8s/
│   ├── applications/   # Manifestos dos microsserviços AgroSense
│   ├── base/           # Configurações base (namespace, etc.)
│   ├── monitoring/     # Prometheus, Grafana e Loki
│   ├── postgres/       # Instâncias do PostgreSQL por serviço
│   └── rabbitmq/       # Mensageria RabbitMQ
└── scripts/            # Scripts utilitários para o cluster
```

---

## 📄 Licença

Este projeto está licenciado sob a licença **MIT**. Consulte o arquivo [LICENSE](./LICENSE) para mais detalhes.
