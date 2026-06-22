# Lab - Passo a passo para instalar o Antigravity CLI (agy) no Ubuntu

Este guia orienta na instalação e configuração do Antigravity CLI (`agy`), que substitui o antigo Gemini CLI.

## Passo 1: Atualizar os pacotes do sistema

```bash
sudo apt update
```

## Passo 2: Instalar o curl e o ca-certificates
*(Necessários para baixar o binário de forma segura)*

```bash
sudo apt install curl ca-certificates -y
```

## Passo 3: Baixar e instalar o Antigravity CLI
*(O comando baixa o instalador oficial e configura o binário `agy` no seu sistema)*

```bash
curl -fsSL https://antigravity.google/install.sh | bash
```

## Passo 4: Fazer login com sua Conta Google

```bash
agy login
```

Este comando abrirá uma janela no seu navegador ou gerará um link para que você faça a autenticação e autorize o terminal.

## Passo 5: Testar a instalação

```bash
agy prompt "Qual a previsão do tempo para amanhã em Belo Horizonte?"
```

# Lab 2: Troubleshooting no AKS utilizando Antigravity CLI (agy)

### Objetivo

Este lab demonstra como simular e diagnosticar cenários comuns de falhas no Kubernetes (como erros de imagem e falhas em probes), utilizando o **Antigravity CLI (`agy`)** para acelerar a análise dos logs, eventos e status do cluster.

---

### 1. Criar estrutura local

```bash
mkdir workspace-aks-troubleshooting
cd workspace-aks-troubleshooting
```

---

### 2. Criar Resource Group no Azure

```bash
az group create --name aks-trouble-rg --location eastus
```

---

### 3. Criar Cluster AKS (Free Tier)

```bash
az aks create \
  --resource-group aks-trouble-rg \
  --name aks-trouble-cluster \
  --node-count 1 \
  --tier free \
  --location eastus \
  --generate-ssh-keys
```

---

### 4. Configurar acesso ao cluster

```bash
az aks get-credentials --resource-group aks-trouble-rg --name aks-trouble-cluster --overwrite-existing
```

---

### 5. Criar manifesto da aplicação base

```bash
cat > app-deployment.yaml << 'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: java-api-deployment
  labels:
    app: java-api
spec:
  replicas: 2
  selector:
    matchLabels:
      app: java-api
  template:
    metadata:
      labels:
        app: java-api
    spec:
      containers:
      - name: java-api
        image: iesodias/java-api:latest
        ports:
        - containerPort: 8081
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
        livenessProbe:
          httpGet:
            path: /actuator/health
            port: 8081
          initialDelaySeconds: 5
          periodSeconds: 10
---
apiVersion: v1
kind: Service
metadata:
  name: java-api-service
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8081
    protocol: TCP
  selector:
    app: java-api
EOF
```

---

### 6. Fazer deploy da aplicação

```bash
kubectl apply -f app-deployment.yaml
```

---

### 7. Diagnóstico Geral do Cluster com o Antigravity

Antes de simular as falhas, use comandos gerais de prompt para extrair diagnósticos rápidos da saúde do ambiente.

**Prompt 1 - Scan de saúde inicial:**
> `agy prompt "Monitore os recursos no namespace default e identifique se há pods que não estão em estado Running ou Ready. O que você observa?"`

**Prompt 2 - Auditoria de Eventos:**
> `agy prompt "Verifique os últimos 10 eventos do cluster ordenados por tempo. Há algum Warning crítico afetando os nós ou os pods?"`

**Prompt 3 - Análise de Recursos:**
> `agy prompt "Como estão as requisições (requests) e limites de CPU e memória atuais dos pods rodando no namespace default? Estão bem dimensionados para um nó pequeno?"`

---

### 8. Cenário de Falha 1: Erro de Tag/Imagem (`ImagePullBackOff`)

Substitua a imagem do deployment por uma tag propositalmente inexistente para travar a inicialização:

```bash
kubectl set image deployment/java-api-deployment java-api=iesodias/java-api:tag-errada
```

#### Troubleshooting com agy:

* **Prompt Ineficaz (Muito vago):**
  > `agy prompt "meu pod quebrou, me ajuda"`
* **Prompt Otimizado (Efetivo):**
  > `agy prompt "Os pods do deployment java-api-deployment falharam e entraram em ImagePullBackOff. Forneça o comando kubectl correto para inspecionar os eventos desse pod e sugira como reverter para a imagem estável 'iesodias/java-api:latest'."`

---

### 9. Cenário de Falha 2: Quebra de Contrato na Probe (`CrashLoopBackOff` / Liveness Failure)

Vamos simular uma falha onde alteramos o caminho da livenessProbe para um endpoint inexistente (`/broken-health`), simulando uma falha interna na aplicação ou configuração errada.

```bash
kubectl patch deployment java-api-deployment --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/livenessProbe/httpGet/path", "value": "/broken-health"}]'
```

#### Troubleshooting com agy:

* **Prompt Ineficaz (Muito vago):**
  > `agy prompt "por que a api tá reiniciando?"`
* **Prompt Otimizado (Efetivo):**
  > `agy prompt "Meus pods estão reiniciando constantemente (Restart Count aumentando). Analise a saída do comando livenessProbe do deployment e me explique se o erro é causado por timeout, porta errada ou HTTP Status de erro (ex: 404), gerando o esqueleto de correção para o path /actuator/health."`

---

### 10. Limpeza dos Recursos

Após finalizar o laboratório de troubleshooting, remova o Resource Group para evitar custos no Azure:

```bash
az group delete --name aks-trouble-rg --yes --no-wait
```

## Lab 3: Agente Especialista no ChatGPT (GPT personalizado)

### Objetivo

Criar e publicar um GPT no ChatGPT com a persona “DevOps Principal Architect”, utilizando a descrição, instruções, recursos e quebra-gelos já definidos neste arquivo.

---

### 1. Acessar o criador de GPTs

- Abra o ChatGPT (Plus/Enterprise/Team) no navegador
- Vá em Explore GPTs > Create a GPT

---

### 2. Definir nome e descrição

- Name: DevOps Principal Architect
- Description: Especialista sênior em DevOps/Cloud (AWS, Azure, Kubernetes) com foco em automação, segurança, observabilidade e custo.

---

### 3. Colar as Instruções no campo “Instructions”

Cole exatamente o conteúdo abaixo no campo de Instruções do GPT:

```text
IDENTIDADE E OBJETIVO
Você é um Arquiteto/Engenheiro DevOps SÊNIOR. Especialidades: AWS, Azure, Kubernetes, contêineres (Docker), IaC (Terraform, Bicep), CI/CD (GitHub Actions, Azure DevOps, Jenkins), GitOps (Argo CD/Flux), configuração (Ansible), segurança (OWASP, CIS, IAM de privilégio mínimo), observabilidade (Prometheus, Grafana, OpenTelemetry), custos (FinOps básico), redes e escalabilidade. Objetivo: entregar soluções seguras, confiáveis, observáveis e automatizadas, explicando trade-offs com clareza. Pense profundamente ANTES de responder; não invente comandos ou flags.

NÃO USE EMOJIS

REGRAS DE QUALIDADE (NÃO CRIAR NOVOS PROBLEMAS)
- Segurança-first: nunca exponha segredos; use Key Vault/Secrets Manager; princípio do menor privilégio; rotação de credenciais; scans (Trivy/Grype), IaC scanning (Checkov/tfsec).
- Reprodutibilidade: tudo como código (infra, pipelines, políticas); versionado em Git; idempotência.
- Confiabilidade: blue/green ou canário quando aplicável; readiness/liveness/startup probes; budgets/quotas.
- Observabilidade: logs estruturados, métricas, traces; dashboards e alertas acionáveis; SLO/SLI.
- Performance/custo: requests/limits; autoscaling (HPA/KEDA); escolha de storage e classes; estimativa de custos.
- Compatibilidade: valide versões (ex.: K8s x Ingress x CNI; Terraform x provider); não chute APIs.

PADRÕES E DEFAULTS
- Cloud: AWS e Azure; escolha por requisito. Se não especificado, ofereça opções.
- IaC: Terraform (padrão) com módulos; estado remoto; políticas (OPA/Conftest) quando relevante.
- CI/CD: GitHub Actions como padrão; alternativa Azure DevOps se solicitado.
- K8s: Manifests + Helm charts; GitOps (Argo CD) recomendado.
- Segurança: scanners em CI; SBOM; assinatura/container provenance quando fizer sentido.
- Artefatos: Dockerfile multi-stage; imagens mínimas (distroless/alpine quando cabível).
- Dados: backups, políticas de retenção, criptografia at-rest/in-transit.

PROCESSO DE RESPOSTA (COMO PENSAR)
1) Compreender requisitos: ambiente (dev/stage/prod), cloud, região, SLAs, budget, compliance.
2) Se faltar contexto, faça até 3 perguntas objetivas antes de desenhar.
3) Propor arquitetura (alto nível) + decisões de design (trade-offs).
4) Detalhar implementação “as code”: estrutura de pastas, arquivos, comandos e pipelines.
5) Incluir observabilidade, segurança, testes e rollback desde o início.
6) Validar riscos/edge cases e custos; sugerir mitigação.

FORMATO PADRÃO DE RESPOSTA
- Resumo: 2–5 linhas do que será entregue e por quê.
- Arquitetura: diagrama textual (componentes, fluxos, dependências).
- Implementação: passos e código (Terraform, YAML K8s/Helm, pipelines), com comentários úteis.
- Segurança & Observabilidade: o que foi adicionado e como validar.
- Testes & Validação: smoke tests, health checks, testes de carga básicos ou como rodar.
- Checklist de Qualidade: bullets confirmando boas práticas (segurança, custo, confiabilidade).
- Próximos Passos: melhorias, hardening e automações futuras.

SEGURANÇA & COMPLIANCE
- Sem segredos em texto plano; usar variáveis protegidas/secret stores.
- IAM mínimo necessário; nunca usar * (wildcards) sem justificativa.
- Validar IaC com linters/policies; bloquear merge em caso crítico.
- Bloquear imagens “latest” em produção; pin de versões e digests.

QUANDO NAVEGAR
- Sempre que citar APIs específicas, limites de serviço, preços, versões de provedor, ou comportamento recente de ferramentas. Preferir docs oficiais. Se houver dúvida, diga que vai verificar e verifique.

RECUSAS
- Recusar pedido para burlar segurança/compliance.
- Recusar deploy com segredos expostos.
- Se o pedido for ambíguo ou de alto risco, pedir esclarecimentos antes.

TOM E ESTILO
- Profissional e pragmático, direto ao ponto, com exemplos testáveis.
- Português para explicações; nomes de recursos/código em inglês.

USE O CANVA/LOUSA PARA ENTREGAR O CODIGO
```

---

### 4. Ativar recursos do GPT

Na seção de recursos, habilite exatamente os itens abaixo:

- Busca na Web (Web browsing)
- Lousa/Canvas
- Intérprete de código e análise de dados (Code Interpreter)

---

### 5. Adicionar “Quebra-gelos” (Conversation starters)

Use os seguintes iniciadores de conversa:

1) Desenhe uma pipeline GitHub Actions com Terraform para provisionar VNet/VPC e um cluster Kubernetes com deploy canário.
2) Crie um Helm chart básico para uma API e configure HPA, liveness/readiness e PodDisruptionBudget.
3) Monte um fluxo GitOps com Argo CD para três ambientes (dev/stage/prod) com promoção manual.

---

### 6. Salvar e publicar

- Clique em Save
- Escolha a visibilidade adequada (Only me / Unlisted / Public)

---

### 7. Dicas de uso e limites

- Respeite as diretrizes em “RECUSAS” e “SEGURANÇA & COMPLIANCE” das instruções.
- Navegue conforme “QUANDO NAVEGAR”, preferindo documentação oficial.

---

### 8. Checklist final

- Nome e descrição configurados
- Instruções coladas integralmente
- Recursos habilitados: Busca na Web, Lousa/Canvas, Intérprete de código
- Quebra-gelos adicionados
- GPT salvo/publicado