# Guia de Boas Práticas: FinOps e Right-Sizing na Nuvem

Este guia reúne conceitos essenciais, estratégias práticas e mentalidades de **FinOps** voltadas para a otimização de custos em infraestrutura de nuvem e contêineres, focando no combate ao desperdício financeiro sem comprometer a estabilidade técnica.

---

## 1. O Princípio do Right-Sizing em Kubernetes

O erro mais comum (e caro) em ambientes de produção é o **superdimensionamento de recursos por medo**. Escalar a infraestrutura com base no "chômetro" gera o que chamamos de desperdício invisível.

* **A armadilha do `requests` inflado:** No Kubernetes, o campo `requests` realiza uma reserva garantida e exclusiva no nó. Mesmo que a sua aplicação utilize apenas **5%** da CPU real no dia a dia, os **95%** restantes ficam bloqueados para qualquer outro Pod.
* **A reação em cadeia do custo:** Se os nós ficam cheios no papel (via reserva), o *Cluster Autoscaler* é forçado a provisionar novas máquinas para abrigar novos Pods, criando nós ociosos e inflando a fatura de nuvem desnecessariamente.
* **O Equilíbrio FinOps:** O objetivo do Right-Sizing não é estrangular a aplicação, mas encontrar a intersecção ideal entre o **consumo real histórico**, uma **folga de segurança sensata** (headroom) e **limites (`limits`) elásticos** para absorver picos de tráfego.

---

## 2. Framework de Diagnóstico para Recursos de Contêineres

Para aplicar o Right-Sizing de forma eficaz, utilize métricas reais de ferramentas como o *Metrics Server*, *Prometheus* ou plataformas de observabilidade.

| Sintoma Observado | Causa Raiz Técnico-Financeira | Ação Corretiva FinOps |
| :--- | :--- | :--- |
| `kubectl top pods` muito abaixo do `requests` configurado. | **Reserva inflada.** O Pod está pagando por CPU/Memória ociosa que nunca utiliza. | Reduzir o `requests` para o patamar do consumo médio real + folga de 20% a 30%. |
| Nós com alto índice de *Allocated resources* (reserva), mas baixo uso real de CPU/Memória. | **Nós supercomprometidos artificialmente.** O cluster está provocando o provisionamento de novos nós sem necessidade real. | Aplicar o Right-Sizing em massa nos Deployments para consolidar e reduzir a contagem de nós ativos. |
| Novos Pods travados com o status `Pending` exibindo o evento `Insufficient cpu`. | **Falta de espaço físico por conta de reservas fantasmas.** Bloqueio de novos deploys mesmo com o hardware ocioso. | Limpar o desperdício de alocação dos Pods vizinhos para abrir espaço interno no cluster. |

---

## 3. Estratégias de Gerenciamento de Tempo (Liga/Desliga)

Nem toda otimização de custo envolve alterar o tamanho da CPU ou da Memória. Muitas vezes, a economia mais agressiva e imediata vem de **eliminar o tempo de execução desnecessário**.

* **Ambientes Não-Produtivos (Desenvolvimento/Homologação/Sandbox):** Estes ambientes costumam ser utilizados estritamente em horário comercial (aproximadamente 40 a 50 horas semanais). Deixá-los ligados **24x7** (168 horas semanais) significa pagar por **mais de 110 horas de ociosidade total** toda semana.
* **Automação sobre Operação:** Confiar que os times vão desligar os recursos manualmente antes de ir embora não funciona. A economia previsível e recorrente exige automação baseada em agendas (como *EventBridge Scheduler*, *CronJobs* ou ferramentas nativas de nuvem) para desligar a computação nas noites de dias úteis e nos fins de semana.
* **Atenção aos Custos Residuais:** Lembre-se de que instâncias e serviços de computação parados (como instâncias EC2 ou nós de clusters pausados) interrompem a cobrança de processamento, mas **recursos persistentes acoplados (como discos EBS/Managed Disks, IPs estáticos e snapshots) continuam gerando custos**. Mapeie esses resíduos.

---

## 4. Mentalidade Operacional FinOps

FinOps não é um projeto com data de término; é uma cultura de responsabilidade financeira compartilhada.

1.  **Monitore antes de agir:** Nunca altere recursos de infraestrutura sem antes validar o histórico de comportamento da aplicação por um período mínimo representativo (ex: 7 a 14 dias para capturar ciclos de negócios).
2.  **Comece por ambientes frios:** Valide o Right-Sizing e as rotinas de desligamento automático primeiro em Dev e Homologação. Mostre o valor gerado e a estabilidade mantida antes de avançar para os clusters de Produção.
3.  **Use limites dinâmicos para segurança:** No Kubernetes, mantenha os `limits` de CPU confortáveis para que a aplicação possa escalar verticalmente em cenários de estresse pontual, mas nunca utilize o valor do limite como base para a sua reserva de custos.