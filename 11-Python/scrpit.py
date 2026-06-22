#!/usr/bin/env python3

def analisar_saude_node(node_info):
    """
    Função que recebe um dicionário com dados de um nó,
    avalia o consumo de CPU e retorna o status de saúde.
    """
    nome = node_info["nome"]
    cpu = node_info["uso_cpu"]
    
    # Controle de fluxo (Condicionais) para classificar o uso
    if cpu >= 90:
        status = "CRITICAL"
    elif cpu >= 75:
        status = "WARNING"
    else:
        status = "OK"
        
    # Retorna uma string formatada usando f-string
    return f"Node: {nome} | CPU: {cpu}% | Status: {status}"


def main():
    # Lista de dicionários simulando dados coletados de uma infraestrutura
    cluster_nodes = [
        {"nome": "aks-nodepool-01", "uso_cpu": 45},
        {"nome": "aks-nodepool-02", "uso_cpu": 78},
        {"nome": "aks-nodepool-03", "uso_cpu": 92},
    ]
    
    print("=== Iniciando Verificação do Cluster ===")
    
    # Laço de repetição (for) para percorrer cada nó da lista
    for node in cluster_nodes:
        # Chamada da função passando o nó atual como argumento
        relatorio = analisar_saude_node(node)
        print(relatorio)


# Garante que o script só execute a função main se for rodado diretamente
if __name__ == "__main__":
    main()