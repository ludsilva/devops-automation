# Guia de Conceitos Essenciais: Observabilidade com Datadog

Este guia aborda os pilares conceituais, a arquitetura de agentes e as melhores práticas de implantação da plataforma **Datadog** para monitoramento de infraestrutura elástica (Virtual Machines) e ambientes orquestrados (Kubernetes).

---

## 1. A Arquitetura do Datadog Agent

O Datadog baseia-se em um modelo de coleta local. O **Agent** é um software leve que roda diretamente nos seus ativos de computação, atuando como o intermediário que coleta e envia telemetria (métricas, logs e traces) de forma segura via HTTPS (porta `443`) para o SaaS da Datadog.



### Diferença de Implantação: Instâncias Nativas vs. Contêineres

* **Instâncias de Computação (IaaS / Máquinas Virtuais):** O Agent é instalado diretamente no Sistema Operacional como um serviço do sistema (systemd/init). Ele possui acesso direto ao hardware virtual para coletar dados agregados de CPU, memória, disco e rede daquela máquina específica.
* **Orquestradores (Kubernetes / CaaS):** Em contêineres, o Agent não é instalado nas aplicações. Ele é distribuído via **DaemonSet** (garantindo que uma réplica do agente rode em cada nó do cluster). Além do Node Agent, utiliza-se o **Cluster Agent**, que atua de forma centralizada para aliviar a carga sobre a API Server do Kubernetes, servindo também como um provedor de métricas para escalonamento automático (HPA).

---

## 2. A Estrutura Unificada de Tags (O Segredo do FinOps e Resolução de Problemas)

O Datadog depende fortemente de metadados. Sem uma estratégia de marcação (**Tagging**), volumes massivos de dados se tornam impossíveis de filtrar. A plataforma recomenda a adoção estrita das três tags globais padrão (*Unified Service Tagging*):

1. **`env`:** Identifica o ciclo de vida do recurso (ex: `prod`, `staging`, `dev`). Impede que alertas de testes poluam o plantão de produção.
2. **`service`:** O nome do microsserviço ou aplicação (ex: `payment-api`, `auth-service`). Agrupa logs e traces sob o mesmo contexto de negócio.
3. **`version`:** A versão exata do software implantado (ex: `1.0.4`, `git-sha-abcd`). Permite correlacionar degradações de performance a um deploy específico.

No Kubernetes, essas tags são injetadas através de labels padronizadas no nível do Deployment (`tags.datadoghq.com/env`, etc.), sendo herdadas automaticamente por logs, métricas e APM.

---

## 3. O Ecossistema de Observabilidade: APM vs. Logs vs. Infraestrutura



Para um troubleshooting eficaz, a telemetria coletada pelo agente divide-se em três verticais correlacionáveis:

### 1. Métricas de Infraestrutura
Dados quantitativos coletados em intervalos de tempo definidos. Mostram o *comportamento do hardware*.
* **Casos de uso:** Alertas de estouro de disco, nós indisponíveis, picos de CPU no cluster.

### 2. Monitoramento de Performance de Aplicação (APM & Tracing)
Mede a experiência interna do código. O APM rastreia o caminho de uma requisição (*Traces*) através de múltiplos microsserviços, calculando as métricas de ouro: **Latência, Erros e Taxa de Requisições (RED method)**.
* **Injeção Automática (Admission Controller):** Em Kubernetes, o Datadog permite instrumentar o APM sem alterar o código do desenvolvedor. O próprio agente injeta as bibliotecas de tracing em tempo de execução com o uso de anotações no pod (`admission.datadoghq.com/enabled: "true"`).

### 3. Gerenciamento de Logs
A trilha de auditoria textual detalhada contendo o contexto do que aconteceu. Ativando o parâmetro `DD_LOGS_INJECTION`, o Datadog vincula o ID do Trace (`trace_id`) diretamente na linha do log da aplicação. 
* **Resultado prático:** Ao encontrar uma requisição lenta ou um erro no gráfico do APM, você clica nele e abre instantaneamente os logs exatos gerados por aquela linha de código específica.

---

## 4. Checklist para Implantações Seguras

Ao desenhar a infraestrutura para suportar o monitoramento via Datadog, garanta os seguintes critérios operacionais:

* **Gerenciamento de Segredos:** Nunca exponha a sua `API Key` diretamente em arquivos de configuração ou repositórios Git. Utilize componentes de secrets nativos da nuvem ou do Kubernetes (`v1/Secret`) referenciados por variáveis de ambiente.
* **Fuso Horário (`Timezones`):** Configure alertas, logs de auditoria e ferramentas cron com fusos horários explícitos ou sob o padrão UTC para evitar falsos positivos em janelas de manutenção globais.
* **Isolamento de Redes:** Certifique-se de que as instâncias isoladas ou nós privados de Kubernetes possuam regras de egresso (Outbound) liberadas para o domínio correspondente ao seu site do Datadog (ex: `datadoghq.com` para EUA ou `datadoghq.eu` para Europa) nas portas seguras.
```