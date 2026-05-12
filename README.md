# BlackTeam Kali Training

Ambiente Docker baseado em Kali Linux para treinos e laboratorios autorizados de BlackTeam.

Este projeto cria um container Kali com ferramentas comuns para reconhecimento, enumeracao,
testes web, passwords, redes, forense basica, reverse/debugging e apoio a labs.

## Estrutura

```text
blackteam-training/
├── Dockerfile
├── docker-compose.yml
├── .dockerignore
├── workspace/   # ficheiros de trabalho, scripts e notas do lab
└── loot/        # outputs, capturas, relatorios e artefactos
```

As pastas `workspace/` e `loot/` ficam no host e sao montadas dentro do container.
Tudo o que guardares nelas continua disponivel depois de fechar o container.

## Requisitos

- Docker instalado
- Docker Compose instalado
- Internet no primeiro build
- Permissao para usar Docker com o teu utilizador

Verificar:

```bash
docker --version
docker compose version
```

## Build da imagem

Na pasta do projeto:

```bash
cd /home/timatias/blackteam-training
docker compose build
```

O primeiro build pode demorar, porque baixa o Kali e instala muitas dependencias.

## Entrar no ambiente

```bash
cd /home/timatias/blackteam-training
docker compose run --rm kali-blackteam
```

Vais entrar no container em:

```text
/workspace
```

## Sair do container

Dentro do container:

```bash
exit
```

Como o comando usa `--rm`, o container temporario e removido ao sair. Os ficheiros em
`workspace/` e `loot/` continuam guardados no host.

## Rebuild depois de alterar o Dockerfile

Sempre que mudares o `Dockerfile`:

```bash
docker compose build --no-cache
```

Se quiseres apenas rebuild normal:

```bash
docker compose build
```

## Atualizar pacotes dentro da imagem

O ideal e atualizar pelo Dockerfile e reconstruir a imagem. Para testes rapidos dentro
do container:

```bash
sudo apt update
sudo apt upgrade -y
```

Essas alteracoes feitas manualmente dentro do container nao sao permanentes se usares
`docker compose run --rm`.

## Comandos uteis do Docker

Listar imagens:

```bash
docker images
```

Listar containers ativos:

```bash
docker ps
```

Listar todos os containers:

```bash
docker ps -a
```

Remover a imagem deste ambiente:

```bash
docker image rm kali-blackteam:latest
```

Limpar cache/builds antigos do Docker:

```bash
docker system prune
```

Usa `docker system prune -a` com cuidado, porque remove imagens nao usadas.

## Ferramentas incluidas

Principais grupos instalados:

- Base: `curl`, `wget`, `git`, `zsh`, `tmux`, `vim`, `jq`, `yq`, `unzip`, `zip`
- Desenvolvimento: `python3`, `pipx`, `ruby`, `golang`, `nodejs`, `npm`, `openjdk-21`
- Rede: `iproute2`, `ping`, `dnsutils`, `traceroute`, `whois`, `netcat`, `socat`
- Captura/analise: `tcpdump`, `tshark`, `wireshark-common`
- Recon/enumeracao: `nmap`, `masscan`, `arp-scan`, `dnsrecon`, `amass`, `sublist3r`
- Web: `gobuster`, `feroxbuster`, `ffuf`, `wfuzz`, `dirb`, `nikto`, `sqlmap`, `whatweb`, `wafw00f`
- Passwords: `hydra`, `john`, `hashcat`, `hashid`, `wordlists`, `seclists`
- AD/Windows/lateral labs: `impacket-scripts`, `evil-winrm`, `smbclient`, `ldap-utils`, `responder`
- Exploit/lab: `metasploit-framework`, `exploitdb`
- Forense/reverse: `binwalk`, `foremost`, `exiftool`, `steghide`, `yara`, `radare2`, `gdb`, `strace`, `ltrace`, `checksec`
- Metapacotes Kali: `kali-tools-top10`, `kali-tools-web`, `kali-tools-passwords`, `kali-tools-information-gathering`, `kali-tools-vulnerability`

## Wordlists

O Dockerfile tenta descomprimir a wordlist `rockyou.txt` automaticamente se existir:

```text
/usr/share/wordlists/rockyou.txt
```

Outras listas comuns ficam em:

```text
/usr/share/seclists
/usr/share/wordlists
```

## Aliases dentro do container

O utilizador `blackteam` tem alguns aliases no `~/.zshrc`:

```bash
ll       # ls -lah
ports    # ss -tulpen
serve    # python3 -m http.server 8000
```

## Permissoes de rede

O `docker-compose.yml` adiciona:

```yaml
cap_add:
  - NET_ADMIN
  - NET_RAW
```

Isto ajuda em ferramentas que precisam trabalhar com pacotes de rede, interfaces e scan.

Se algum exercicio exigir acesso mais profundo ao host ou a rede, avalia caso a caso.
Evita usar `--privileged` sem necessidade.

## Exemplo de fluxo de trabalho

Entrar no ambiente:

```bash
cd /home/timatias/blackteam-training
docker compose run --rm kali-blackteam
```

Criar uma pasta para o lab:

```bash
mkdir -p /workspace/lab-01
cd /workspace/lab-01
```

Guardar resultados:

```bash
nmap -sV -oA /loot/lab-01-nmap 10.10.10.10
```

Sair:

```bash
exit
```

Depois, no host, os ficheiros ficam em:

```text
/home/timatias/blackteam-training/workspace
/home/timatias/blackteam-training/loot
```

## Troubleshooting

Erro de permissao ao usar Docker:

```bash
sudo usermod -aG docker $USER
```

Depois faz logout/login.

Erro de DNS ou internet no build:

```bash
docker run --rm alpine ping -c 3 8.8.8.8
docker run --rm alpine nslookup kali.org
```

Rebuild limpo se algo ficou inconsistente:

```bash
docker compose build --no-cache
```

Ver a configuracao final do Compose:

```bash
docker compose config
```

## Nota de uso

Usa este ambiente apenas em sistemas, redes, CTFs, laboratorios e alvos onde tens
autorizacao explicita. Mantem outputs sensiveis dentro de `loot/` e evita misturar
artefactos de labs diferentes.
