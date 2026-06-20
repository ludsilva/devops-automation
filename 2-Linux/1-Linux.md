# Lab Prático: Comandos Essenciais do Linux

## Parte 1 - Gerenciamento de Arquivos e Diretórios (Passo a Passo)

Vamos começar criando uma estrutura básica de arquivos e diretórios para praticar todos os comandos seguintes.

### Passo 1: Criar uma pasta de trabalho
```bash
mkdir -p ~/lab-linux/arquivos
cd ~/lab-linux
```
- `mkdir -p` cria a pasta principal e subpastas se necessário.
- `cd` entra no diretório de trabalho.

### Passo 2: Navegar e listar conteúdo
```bash
ls
ls -l
ls -a
ls -lh
```
- `ls`: lista arquivos.
- `ls -l`: mostra detalhes como permissões e tamanho.
- `ls -a`: exibe arquivos ocultos.
- `ls -lh`: mostra tamanhos legíveis (KB, MB).

### Passo 3: Criar arquivos vazios e navegar entre pastas
```bash
touch arquivos/um.txt
mkdir -p arquivos/subpasta
cd arquivos
pwd
```
- `touch` cria arquivo vazio.
- `mkdir` cria diretório.
- `cd` entra na pasta.
- `pwd` mostra o caminho atual.

###  Passo 4: Voltar um nível e criar mais pastas
```bash
cd ..
mkdir backups
```
- `cd ..` volta uma pasta.
- `mkdir backups` cria outra pasta.

### Passo 5: Remover diretórios vazios
```bash
mkdir temp
rmdir temp
```
- `rmdir` remove diretório vazio.

### Passo 6: Remover arquivos e pastas (com cuidado!)
```bash
rm arquivos/um.txt
rm -r arquivos/subpasta
rm -rf backups
```
- `rm` remove arquivos.
- `rm -r` remove recursivamente.
- `rm -rf` força remoção sem confirmação (cuidado!).

### Passo 7: Criar dois arquivos e copiá-los
```bash
mkdir arquivos
cd arquivos
touch a.txt b.txt
cp a.txt copia_de_a.txt
cp -r ../arquivos ../arquivos_backup
```
- `cp` copia arquivos.
- `cp -r` copia diretórios recursivamente.

### Passo 8: Mover e renomear arquivos
```bash
mv b.txt renomeado.txt
mv renomeado.txt ../
```
- `mv` move ou renomeia arquivos.

### Passo 9: Verificar tipo de arquivo
```bash
file a.txt
```
- `file` mostra o tipo do conteúdo do arquivo.

---

## Parte 2 - Manipulação de Conteúdo de Arquivos (Passo a Passo)

### Passo 1: Preparar arquivos com conteúdo
```bash
cd ~/lab-linux
cd arquivos
echo -e "linha 1\nlinha 2\nlinha 3" > a.txt
echo -e "erro: falha\ninfo: ok\naviso: cuidado" > log.txt
echo -e "nome idade\njoao 30\nmaria 25" > dados.txt
```
- `echo -e` imprime múltiplas linhas no terminal, `>` salva no arquivo.

### Passo 2: Visualizar conteúdo com `cat` e `less`
```bash
cat a.txt
less log.txt  # Use q para sair
```
- `cat` mostra o conteúdo de uma vez.
- `less` permite navegação (setas, barra de rolagem).

### Passo 3: Ver as primeiras e últimas linhas
```bash
head -n 2 log.txt
tail -n 2 log.txt
tail -f log.txt  # Use Ctrl+C para sair
```
- `head` mostra o início.
- `tail` mostra o final.
- `tail -f` acompanha atualizações em tempo real.

### Passo 4: Buscar textos com `grep`
```bash
grep "erro" log.txt
grep -i "AVISO" log.txt
grep -r "joao" .
```
- `grep` procura por textos.
- `-i` ignora maiúsculas/minúsculas.
- `-r` busca em subdiretórios.

### Passo 5: Substituir palavras com `sed`
```bash
sed 's/joao/JOÃO/g' dados.txt
```
- `sed` faz substituições no texto.
- `s/antigo/novo/g` troca todas as ocorrências.

### Passo 6: Manipular colunas com `awk`
```bash
awk '{print $1}' dados.txt
awk '{print $2}' dados.txt
```
- `awk` permite trabalhar com colunas de texto.

### Passo 7: Contar linhas, palavras e bytes com `wc`
```bash
wc -l dados.txt
wc -w dados.txt
wc -c dados.txt
```
- `wc` mostra estatísticas: linhas (`-l`), palavras (`-w`), bytes (`-c`).

### Passo 8: Ordenar linhas com `sort`
```bash
sort dados.txt
```
- `sort` organiza as linhas em ordem alfabética ou numérica.

### Passo 9: Comparar arquivos com `diff`
```bash
echo -e "nome idade\njoao 30\nmaria 22" > dados_v2.txt
diff dados.txt dados_v2.txt
```
- `diff` compara diferenças entre arquivos linha a linha.

---

## Parte 3 - Informações e Gerenciamento do Sistema (Passo a Passo)

### Passo 1: Ver informações do sistema
```bash
uname -a
```
- `uname -a` mostra o nome do kernel, versão, arquitetura e nome do host.

### Passo 2: Ver processos em tempo real
```bash
top
```
- `top` exibe os processos ativos e uso de CPU/memória em tempo real.

### Passo 3: Visualizar processos com mais detalhes
```bash
ps aux
ps aux | grep bash
```
- `ps aux` mostra todos os processos do sistema com informações detalhadas.
- `grep` filtra processos específicos (ex: `bash`).

### Passo 4: Encerrar processos manualmente
```bash
kill 1234
kill -9 1234
```
- `kill` envia sinal para encerrar um processo.
- `-9` força o encerramento imediato.

> Dica: use `ps aux | grep nome_do_programa` para descobrir o PID.

### Passo 5: Ver uso de disco e diretórios
```bash
df -h
du -sh ~/lab-linux
```
- `df -h` mostra o uso do disco em todas as partições.
- `du -sh` mostra o tamanho da pasta especificada.

### Passo 6: Ver uso de memória e tempo de atividade
```bash
free -m
uptime
```
- `free -m` mostra o uso de memória RAM e swap em MB.
- `uptime` mostra há quanto tempo o sistema está ligado.

### Passo 7: Ver quem está logado no sistema
```bash
who
w
```
- `who` lista usuários logados.
- `w` mostra usuários logados e o que estão fazendo.

### Passo 8: Ver histórico de comandos e reiniciar
```bash
history
sudo shutdown -h now
sudo reboot
```
- `history` mostra comandos executados anteriormente.
- `shutdown` desliga o sistema.
- `reboot` reinicia o sistema.

---

## Parte 4 - Comandos de Rede (Passo a Passo)

### Passo 1: Testar conectividade com `ping`
```bash
ping google.com
```
- `ping` envia pacotes ICMP para testar se o host está acessível e mede o tempo de resposta.
- Use `Ctrl+C` para interromper o teste.

### Passo 2: Ver informações da interface de rede
```bash
ip addr
ip route
```
- `ip addr` mostra os IPs atribuídos às interfaces de rede.
- `ip route` exibe a tabela de roteamento da máquina.

### Passo 3: Ver portas e conexões abertas
```bash
# Instalar o pacote net-tools
sudo apt install net-tools -y

# Ver conexões e portas abertas
netstat -tulnp
```
- `netstat -tulnp` mostra as portas TCP e UDP abertas e os processos associados.

### Passo 4: Conectar em uma máquina remota com `ssh`
```bash
ssh usuario@192.168.1.10
```
- `ssh` estabelece uma conexão segura com outro computador na rede.

> Substitua `usuario` e `IP` pelo alvo desejado.

### Passo 5: Enviar e receber arquivos com `scp`
```bash
scp arquivo.txt usuario@192.168.1.10:/home/usuario/
scp usuario@192.168.1.10:/home/usuario/arquivo.txt ./
```
- `scp` envia ou recebe arquivos de forma segura via SSH.
- O primeiro exemplo envia, o segundo baixa.

### Passo 6: Baixar arquivos com `wget` e `curl`
```bash
wget https://example.com/arquivo.zip
curl -O https://example.com/arquivo.zip
```
- `wget` e `curl -O` fazem download direto de arquivos da internet.
- `curl` também pode ser usado para acessar APIs ou testar endpoints:
```bash
curl https://api.github.com
```

---

## Parte 5 - Permissões e Propriedades de Arquivos (Passo a Passo)

### Passo 1: Criar arquivos de teste
```bash
cd ~/lab-linux/arquivos
touch permissao.txt
```
- `touch` cria um novo arquivo vazio chamado `permissao.txt`.

### Passo 2: Ver permissões atuais do arquivo
```bash
ls -l permissao.txt
```
- `ls -l` mostra as permissões, dono e grupo do arquivo.

### Passo 3: Alterar permissões com `chmod`
```bash
chmod 755 permissao.txt
ls -l permissao.txt
chmod u-x permissao.txt
ls -l permissao.txt
```
- `chmod` define permissões numéricas (ex: 755 = leitura/escrita/execução).
- `u-x` remove permissão de execução do usuário.

### Passo 4: Ver usuário atual e criar um novo (opcional)
```bash
whoami
# sudo adduser testeusuario  # caso deseje criar um usuário para testes
```
- `whoami` mostra seu nome de usuário atual.
- `adduser` cria um novo usuário no sistema (exige sudo).

### Passo 5: Alterar dono do arquivo com `chown`
```bash
sudo chown $USER permissao.txt
```
- `chown` muda o proprietário do arquivo para o usuário atual (variável `$USER`).

### Passo 6: Alterar grupo do arquivo com `chgrp`
```bash
sudo chgrp $(id -gn) permissao.txt
```
- `chgrp` muda o grupo proprietário do arquivo.
- `id -gn` retorna o nome do grupo atual do usuário.

### Passo 7: Combinar `chown` com grupo
```bash
sudo chown $USER:$USER permissao.txt
```
- Isso muda dono e grupo de uma vez só.

---

## Extra: Cheatsheet de permissões

| Permissão | Símbolo | Valor | Descrição |
|------------|---------|--------|------------|
| Read | r | 4 | Ler arquivo ou listar diretório |
| Write | w | 2 | Modificar arquivo ou diretório |
| Execute | x | 1 | Executar arquivo ou acessar diretório |
| Nenhuma | - | 0 | Sem permissão |

### Combinações comuns
Combinações Comuns

| Valor | Permissão | Descrição |
|---------|------------|------------|
| 0 | --- | Nenhuma permissão |
| 1 | --x | Apenas execução |
| 2 | -w- | Apenas escrita |
| 3 | -wx | Escrita e execução |
| 4 | r-- | Apenas leitura |
| 5 | r-x | Leitura e execução |
| 6 | rw- | Leitura e escrita |
| 7 | rwx | Leitura, escrita e execução |

---

## Parte 6 - Gerenciamento de Pacotes (Passo a Passo)

### Passo 1: Atualizar lista de pacotes no Ubuntu/Debian (`apt`)
```bash
sudo apt update
```
- `apt update` consulta os repositórios e atualiza a lista de pacotes disponíveis.

### Passo 2: Instalar um pacote com `apt`
```bash
sudo apt install cowsay
```
- `apt install` baixa e instala um pacote. Exemplo divertido com `cowsay`.

### Passo 3: Remover um pacote com `apt`
```bash
sudo apt remove cowsay
```
- `apt remove` desinstala o pacote, mas pode deixar arquivos de configuração.

> Dica: use `sudo apt purge` para remover tudo.

### Passo 4: Atualizar pacotes no CentOS/RHEL (`yum`)
```bash
sudo yum update
```
- `yum update` atualiza todos os pacotes do sistema.

### Passo 5: Instalar pacote com `yum`
```bash
sudo yum install httpd
```
- `yum install` instala um pacote no CentOS ou RHEL.

### Passo 6: Remover pacote com `yum`
```bash
sudo yum remove httpd
```
- `yum remove` desinstala o pacote especificado.

### Passo 7: Usar o `dnf` (Fedora e versões mais recentes do CentOS)
```bash
sudo dnf update
sudo dnf install nano
sudo dnf remove nano
```
- `dnf` é o substituto moderno do `yum`. Uso semelhante, mas mais rápido e seguro.

> Todos esses comandos precisam de permissões de administrador (sudo).

---

## Parte 7 - Comandos Extras e Boas Práticas no Terminal (Passo a Passo)

### Passo 1: Consultar ajuda com o `man`
```bash
man ls
```
- `man` mostra o manual do comando, com todas as opções disponíveis.
- Use `q` para sair do manual.

### Passo 2: Criar atalhos com `alias`
```bash
alias ll='ls -l'
ll
```
- `alias` permite criar comandos personalizados para facilitar o uso.
- `ll` agora executa `ls -l`.

> Obs: para tornar permanente, adicione no `~/.bashrc` ou `~/.zshrc`

### Passo 3: Ver histórico de comandos
```bash
history | tail -n 5
```
- `history` mostra os últimos comandos executados.
- `| tail -n 5` exibe apenas os 5 mais recentes.

### Passo 4: Executar comandos como administrador com `sudo`
```bash
sudo whoami
```
- `sudo` executa comandos como root (usuário administrador).
- `whoami` retorna o nome do usuário atual.

### Passo 5: Usar autocompletar com Tab
- Digite parte do nome de um comando ou arquivo e pressione `Tab` para completar automaticamente.
```bash
cd ~/lab[TAB]       # completa lab-linux
```

### Passo 6: Redirecionar saída de comandos
```bash
ls -l > listagem.txt
cat listagem.txt
```
- `>` redireciona a saída para um arquivo (sobrescreve).
- `>>` adiciona no final do arquivo (sem apagar o conteúdo anterior).

### Passo 7: Usar pipes para combinar comandos
```bash
ps aux | grep bash
```
- O símbolo `|` envia a saída de um comando para outro comando.
- Aqui usamos `ps aux` e passamos o resultado para `grep bash`.

---