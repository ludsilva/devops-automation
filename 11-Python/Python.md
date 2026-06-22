# Guia Fundamental de Python

Este guia consolida os conceitos fundamentais da linguagem Python estruturados para automação, análise de logs, manipulação de arquivos de configuração e troubleshooting de infraestrutura.

---

## 1. Ambientes Virtuais e Fundamentos de Sintaxe

Para garantir o isolamento das dependências de scripts e ferramentas de automação, utiliza-se o ecossistema nativo do módulo `venv`.

```bash
# Criação de um ambiente isolado na pasta local .venv
python3 -m venv .venv

# Ativação do ambiente no ecossistema Linux/Bash
source .venv/bin/activate
```

### Tipagem Dinâmica e Interpolação de Strings
Python infere os tipos de dados em tempo de execução. Para construir mensagens parametrizadas (como alertas ou payloads de API), a abordagem recomendada é o uso de **f-strings** (strings formatadas).

```python
cluster_name = "aks-prod-01"   # String (str)
node_count = 5                 # Inteiro (int)
billing_rate = 0.42            # Ponto Flutuante (float)
is_healthy = True              # Booleano (bool)

# Exemplo de interpolação avançada com f-string
alerta = f"STATUS: {cluster_name} | Nós Ativos: {node_count} | Saudável: {is_healthy}"
print(alerta)
```

---

## 2. Estruturas de Dados Essenciais

A manipulação de dados de infraestrutura exige o domínio de duas coleções básicas: **Listas** (coleções ordenadas) e **Dicionários** (estruturas do tipo chave-valor).

### Listas (`list`) e Laços de Repetição (`for`)
Úteis para iterar sobre coleções de recursos, como uma lista de IPs, IDs de instâncias ou namespaces.

```python
# Definindo uma lista de pods com problema
pods_com_falha = ["api-pod-1", "db-pod-0", "auth-pod-3"]

# Iterando sobre a coleção de forma sequencial
for pod in pods_com_falha:
    print(f"Executando 'kubectl describe pod {pod}'...")
```

### Dicionários (`dict`)
Ideais para representar objetos complexos de infraestrutura, simulando o comportamento de payloads JSON e manifestos YAML.

```python
# Estrutura chave-valor para metadados de um servidor
servidor = {
    "hostname": "nginx-ingress-01",
    "ip_interno": "10.0.4.15",
    "ambiente": "producao",
    "cpu_cores": 4
}

# Acesso seguro utilizando o método .get() para evitar exceções caso a chave não exista
regiao = servidor.get("region", "us-east-1") 
print(f"Servidor alocado na região: {regiao}")
```

---

## 3. Modularização, Controle de Fluxo e Tratamento de Erros

A automação resiliente exige o isolamento de lógicas em funções, controle de fluxo inteligente e contenção de exceções para evitar que falhas de rede ou de arquivos derrubem o pipeline.

### Funções (`def`) e Condicionais (`if/elif/else`)
```python
def avaliar_consumo_cpu(porcentagem):
    """Retorna a severidade com base no uso de CPU."""
    if porcentagem >= 90:
        return "CRITICAL"
    elif porcentagem >= 70:
        return "WARNING"
    else:
        return "OK"

# Invocação da função externa
status_atual = avaliar_consumo_cpu(85)
```

### Resiliência com Blocos `try / except / finally`
Ao interagir com o sistema operacional, chamadas de rede ou conversões de tipos, utilize o tratamento de erros para capturar falhas previsíveis.

```python
entrada_usuario = "85.5"

try:
    # Tentativa de conversão direta que pode falhar se a string contiver pontos decimais
    uso_cpu = int(entrada_usuario)
except ValueError as erro:
    print(f"Falha na conversão de tipo. Detalhes: {erro}")
    # Tratamento alternativo (fallback)
    uso_cpu = int(float(entrada_usuario))
else:
    print("Conversão executada sem erros estruturais.")
finally:
    print("Etapa de telemetria concluída.")
```

---

## 4. Persistência de Arquivos e Manipulação de JSON

A leitura de arquivos de log textuais e o parseamento de arquivos de configuração no formato JSON são rotinas mandatórias no cotidiano de DevOps.

### Manipulação de Arquivos de Texto (`open` com Context Manager)
O bloco `with` garante que os descritores de arquivos (file descriptors) sejam devidamente fechados pelo sistema operacional imediatamente após o término do bloco.

```python
# Escrita de logs em disco (modo 'w' sobrescreve, modo 'a' adiciona ao final)
with open("deploy.log", "w") as arquivo_log:
    arquivo_log.write("2026-06-22 10:00:00 [INFO] Iniciando deploy do microsserviço\n")
    arquivo_log.write("2026-06-22 10:01:15 [ERROR] Timeout de conexão com o banco\n")

# Leitura linha a linha otimizada para economia de memória RAM
with open("deploy.log", "r") as arquivo_log:
    for linha in arquivo_log:
        if "[ERROR]" in linha:
            print(f"Anomalia detectada: {linha.strip()}")
```

### Serialização e Desserialização de JSON
O módulo nativo `json` realiza a conversão de dicionários Python para arquivos JSON (*dump*) e vice-versa (*load*).

```python
import json

# Dicionário representando o estado atual da configuração
config_payload = {
    "app_id": "payment-api",
    "timeout_seconds": 30,
    "feature_flags": {"enable_retry": True, "enable_cache": False}
}

# Serialização: Gravando o dicionário estruturado como arquivo JSON em disco
with open("config.json", "w") as arquivo_json:
    json.dump(config_payload, arquivo_json, indent=4)

# Desserialização: Carregando o arquivo JSON de volta para um dicionário Python
with open("config.json", "r") as arquivo_json:
    dados_carregados = json.load(arquivo_json)

print(f"Configuração carregada com sucesso para a aplicação: {dados_carregados['app_id']}")
```