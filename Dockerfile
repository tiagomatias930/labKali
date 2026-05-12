FROM kalilinux/kali-rolling:latest

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PIPX_HOME=/opt/pipx \
    PIPX_BIN_DIR=/usr/local/bin

ARG USERNAME=blackteam
ARG USER_UID=1000
ARG USER_GID=1000

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        git \
        gnupg \
        lsb-release \
        sudo \
        zsh \
        tmux \
        vim \
        nano \
        less \
        man-db \
        unzip \
        zip \
        p7zip-full \
        file \
        jq \
        yq \
        build-essential \
        make \
        gcc \
        g++ \
        pkg-config \
        python3 \
        python3-dev \
        python3-pip \
        python3-venv \
        pipx \
        ruby \
        ruby-dev \
        golang \
        openjdk-17-jre-headless \
        nodejs \
        npm \
        iproute2 \
        iputils-ping \
        dnsutils \
        traceroute \
        whois \
        net-tools \
        netcat-traditional \
        socat \
        openssh-client \
        openvpn \
        proxychains4 \
        tor \
        tcpdump \
        tshark \
        wireshark-common \
        nmap \
        masscan \
        arp-scan \
        enum4linux-ng \
        smbclient \
        rpcbind \
        ldap-utils \
        snmp \
        onesixtyone \
        hydra \
        john \
        hashcat \
        hashid \
        hashcat-utils \
        wordlists \
        seclists \
        gobuster \
        feroxbuster \
        ffuf \
        wfuzz \
        dirb \
        nikto \
        sqlmap \
        wafw00f \
        whatweb \
        dnsrecon \
        sublist3r \
        amass \
        metasploit-framework \
        exploitdb \
        evil-winrm \
        impacket-scripts \
        responder \
        mitmproxy \
        bettercap \
        binwalk \
        foremost \
        libimage-exiftool-perl \
        steghide \
        yara \
        radare2 \
        gdb \
        ltrace \
        strace \
        patchelf \
        checksec \
        kali-tools-top10 \
        kali-tools-web \
        kali-tools-passwords \
        kali-tools-information-gathering \
        kali-tools-vulnerability && \
    pipx ensurepath && \
    wordlists_dir=/usr/share/wordlists && \
    if [ -f "${wordlists_dir}/rockyou.txt.gz" ]; then gzip -dk "${wordlists_dir}/rockyou.txt.gz"; fi && \
    groupadd --gid "${USER_GID}" "${USERNAME}" 2>/dev/null || true && \
    useradd --uid "${USER_UID}" --gid "${USER_GID}" -m -s /bin/zsh "${USERNAME}" && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USERNAME}" && \
    chmod 0440 "/etc/sudoers.d/${USERNAME}" && \
    mkdir -p /workspace /tools /loot && \
    chown -R "${USERNAME}:${USERNAME}" /workspace /tools /loot && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER ${USERNAME}
WORKDIR /workspace

RUN mkdir -p ~/.config/proxychains && \
    printf '%s\n' \
        'alias ll="ls -lah"' \
        'alias ports="ss -tulpen"' \
        'alias serve="python3 -m http.server 8000"' \
        'export PATH="$HOME/go/bin:/usr/local/go/bin:$PATH"' \
        > ~/.zshrc

CMD ["/bin/zsh"]
