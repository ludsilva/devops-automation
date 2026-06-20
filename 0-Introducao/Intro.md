# Pré-requisitos para o Lab DevOps Automation

Este documento lista os pré-requisitos necessários para acompanhar todos os módulos do curso DevOps Automation. Escolha seu sistema operacional e siga o passo a passo correspondente para garantir que seu ambiente está pronto.

---

## 🔧 Se você está usando **Ubuntu (nativo ou em VM)**

### 1. Atualize o sistema e instale ferramentas básicas:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl unzip software-properties-common gnupg unzip
```

### 2. Instale o Git e configure:

```bash
sudo apt install git -y
git config --global user.name "Seu Nome"
git config --global user.email "seu@email.com"
git --version
```

### 3. Instale o Docker:

```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
newgrp docker
sudo docker run hello-world
```

### 4. Instale o AWS CLI:

Para instalar o AWS CLI, você precisará baixar o pacote correto para a arquitetura do seu sistema.

**Para sistemas x86_64 (Intel/AMD):**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
```

**Para sistemas ARM64:**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
```

Após baixar o arquivo correto para sua arquitetura, execute os seguintes comandos para descompactar e instalar:
```bash
unzip awscliv2.zip
sudo ./aws/install
aws --version
```

### 5. Instale o Azure CLI:

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
az version
```

### 7. Instale o Terraform:

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com noble main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

sudo apt update && sudo apt install terraform -y
terraform -version
```

### 8. Instale o Ansible:

```bash
sudo apt install ansible -y
ansible --version
```

### 9. Instale o kubectl e o watch:

Para instalar o kubectl, você precisará baixar o binário correto para a arquitetura do seu sistema. Primeiro, obtenha a versão estável mais recente:

```bash
KUBECTL_VERSION=$(curl -Ls https://dl.k8s.io/release/stable.txt)
echo "Versão estável do kubectl: $KUBECTL_VERSION"
```

**Para sistemas x86_64 (Intel/AMD):**
```bash
curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"
```

**Para sistemas ARM64:**
```bash
curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/arm64/kubectl"
```

Após baixar o binário correto para sua arquitetura, execute os seguintes comandos para instalá-lo e verificar a versão:
```bash
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

Para instalar o `watch`:
```bash
sudo apt install -y watch
watch --version
```

### 11. Instale o VS Code:

Baixe em: [https://code.visualstudio.com/](https://code.visualstudio.com/)
E instale as extensões: Docker, Terraform, YAML, GitHub Pull Requests

---

## Checklist
- [x] Git instalado e configurado
- [x] Docker instalado e testado
- [x] AWS CLI instalado e testado
- [x] Azure CLI instalado e testado
- [x] Terraform instalado e testado
- [x] Ansible instalado e testado
- [x] kubectl instalado e testado
- [x] watch instalado e testado
- [x] VS Code instalado e extensões configuradas