# Curso DevOps: Automação sem Enrolação

## Sobre o Curso

Curso 100% prático e direto ao ponto, focado em preparar profissionais para automatizar infraestrutura, pipelines e ambientes cloud utilizando as principais ferramentas do mercado DevOps.

---

## Estrutura do Repositório

### 00. Introdução
- Visão geral do curso
- Pré-requisitos de instalação (Git, Docker, AWS CLI, Azure CLI, Terraform, Ansible, kubectl, etc.)
- Guia de setup para Ubuntu, WSL2 e macOS

### 01. Fundamentos Essenciais
**Objetivo:** Dominar as ferramentas básicas necessárias para DevOps

#### Git Essencial
- Comandos fundamentais: clone, add, commit, push, pull
- Branches, merge e pull requests
- Tags e versionamento
- Automação com funções personalizadas

#### Linux Essencial
- Navegação e manipulação de arquivos
- Permissões e usuários
- Processos e gerenciamento de recursos

#### Vi Essencial
- Modos de edição
- Comandos básicos de navegação
- Busca e substituição

---

### 02. Containers com Docker
**Objetivo:** Containerizar aplicações e criar ambientes reproduzíveis

- Conceitos de imagens e containers
- Docker CLI completo (build, run, exec, logs, ps, stop, rm)
- Dockerfile multi-stage para otimização
- Docker Compose para orquestração local
- Push de imagens para Docker Hub
- **Labs práticos:**
  - Containerização de aplicação Node.js
  - Containerização de API FastAPI (Python)
  - Docker Compose com PostgreSQL
  - .gitignore para projetos Docker

---

### 03. Cloud Computing (AWS e Azure)
**Objetivo:** Provisionar recursos cloud via console e CLI

#### AWS
- Criação de instâncias EC2 (Ubuntu)
- Configuração de segurança (Security Groups)
- Elastic IP para IP fixo
- User data para automação de inicialização
- Buckets S3 com versionamento e políticas de segurança
- AWS CLI para automação

#### Azure
- Criação de VMs no Azure
- Configuração de NSG (Network Security Groups)
- Gerenciamento via Azure CLI

---

### 04. Terraform Essencial
**Objetivo:** Infraestrutura como Código (IaC) em AWS e Azure

- Conceitos de IaC e benefícios
- Estrutura de projeto Terraform (main.tf, variables.tf, outputs.tf, versions.tf)
- Providers AWS e Azure
- State remoto com Azure Storage
- Módulos reutilizáveis
- **Labs práticos:**
  - Provisionamento de VM no Azure
  - Criação de buckets S3 com políticas
  - Estrutura profissional de projetos Terraform

---

### 05. Automação CLI (AWS e Azure)
**Objetivo:** Automatizar tarefas com scripts e comandos CLI

- AWS CLI avançado
- Azure CLI avançado
- Scripts de automação para provisionamento
- Integração com pipelines

---

### 06. Ansible
**Objetivo:** Configuração como código para automação de servidores

- Conceitos de playbooks e inventários
- Módulos principais (apt, yum, docker_container, user, file, systemd)
- Criação de VMs no Azure para testes
- **Labs práticos:**
  - Instalação de Docker via Ansible
  - Deploy de aplicação Java containerizada
  - Gerenciamento de usuários e permissões
  - Configuração de estrutura de pastas

---

### 07. GitHub Actions
**Objetivo:** CI/CD moderno com automação de pipelines

- Conceito de workflows e jobs
- Triggers (push, pull_request, workflow_dispatch)
- Secrets e variáveis de ambiente
- **Labs práticos:**
  - Pipeline básica de Hello World
  - CI/CD para aplicação Java com Maven
  - Build e push de imagens Docker para Azure Container Registry (ACR)
  - Scan de segurança com Trivy
  - Infraestrutura com Terraform + Ansible integrado ao GitHub Actions
  - Botão de destruição de recursos via workflow_dispatch

---

### 08. Kubernetes
**Objetivo:** Orquestração de containers em produção

- Conceitos fundamentais: Pods, Deployments, Services, Namespaces
- Azure Kubernetes Service (AKS) no Free Tier
- Criação de cluster com Terraform
- Instalação de Ingress Controller (NGINX) via Helm
- KEDA para autoescalamento baseado em eventos
- **Labs práticos (11 labs completos):**
  1. Criação de cluster AKS com Terraform
  2. Primeiro Pod manual
  3. ReplicaSet para alta disponibilidade
  4. Deployment com rolling updates e rollback
  5. Exposição via LoadBalancer
  6. Isolamento com Namespaces (dev, hml, prod)
  7. Requests & Limits de CPU/Memória
  8. Health checks (liveness e readiness probes)
  9. HPA (Horizontal Pod Autoscaler)
  10. Ingress com domínio nip.io
  11. KEDA com scale-to-zero baseado em cron

---

### 09. Datadog - Observabilidade
**Objetivo:** Monitorar aplicações e infraestrutura em produção

- Integração do Datadog com AKS
- APM (Application Performance Monitoring)
- Coleta de logs e métricas
- Dashboards personalizados
- **Labs práticos:**
  - Instalação do Datadog Agent via Helm
  - Monitoramento de aplicação Java com APM
  - Configuração de logs estruturados

---

### 10. IA para DevOps
**Objetivo:** Acelerar troubleshooting e automação com IA

#### Gemini CLI
- Instalação e configuração
- Uso para troubleshooting de clusters Kubernetes
- Automação de comandos

#### Agentes Personalizados no ChatGPT
- Criação de GPT especialista em DevOps
- Configuração de instruções, recursos e quebra-gelos
- **Labs práticos:**
  - Instalação do Gemini CLI no Ubuntu
  - Troubleshooting de AKS com prompts otimizados
  - Criação de agente DevOps Principal Architect no ChatGPT

---

### 11. Python para DevOps
**Objetivo:** Automação e scripts com Python

- Instalação e configuração de ambiente virtual
- Fundamentos da linguagem (variáveis, tipos, condicionais, loops)
- Funções, listas e estruturas de dados
- Debug no PyCharm
- **Labs práticos:**
  - Setup de ambiente Python
  - Scripts de automação básica
  - Debug avançado no PyCharm

---

## Ferramentas Utilizadas

- **Controle de Versão:** Git, GitHub
- **Containers:** Docker, Docker Compose
- **Cloud:** AWS, Azure
- **IaC:** Terraform
- **Configuração:** Ansible
- **CI/CD:** GitHub Actions
- **Orquestração:** Kubernetes (AKS), Helm, KEDA
- **Observabilidade:** Datadog
- **IA:** Gemini CLI, ChatGPT
- **Linguagens:** Python, Shell Script

---

## Licença

Este material é de uso **exclusivo para alunos do curso**. Redistribuição não autorizada é proibida.

---

## Sobre o Instrutor

**Ieso Dias** - Engenheiro DevOps com experiência prática em automação de infraestrutura, pipelines CI/CD e cloud computing (AWS/Azure).


---

**Bons estudos e automatize tudo!**