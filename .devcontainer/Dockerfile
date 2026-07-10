FROM texlive/texlive:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo git poppler-utils \
    && useradd -m -s /bin/bash vscode \
    && echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode \
    && chmod 0440 /etc/sudoers.d/vscode \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace