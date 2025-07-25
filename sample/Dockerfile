FROM ubuntu:jammy

# 必要なパッケージをインストール
RUN apt-get update && \
    apt-get install -y \
        curl \
        wget \
        git \
        build-essential \
        software-properties-common \
        ca-certificates \
        gnupg \
        lsb-release && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Python 3.13をインストール
RUN add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update && \
    apt-get install -y \
        python3.13 \
        python3.13-dev \
        python3.13-venv \
        python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# python3エイリアスをPython 3.13に設定
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 1 && \
    update-alternatives --set python3 /usr/bin/python3.13

# nvmをインストール
ENV NVM_VERSION=v0.39.0
ENV NODE_VERSION=22
ENV NVM_DIR=/root/.nvm

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

# nvmを使用してNode.js 22をインストール
RUN bash -c "source $NVM_DIR/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm use $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    node --version && npm --version"

# Claude Codeをグローバルにインストール
RUN bash -c "source $NVM_DIR/nvm.sh && \
    nvm use $NODE_VERSION && \
    npm install -g @anthropic-ai/claude-code"

# PATHにnodeとnpmを追加（実際のインストールパスを確認して設定）
RUN bash -c "source $NVM_DIR/nvm.sh && \
    nvm use $NODE_VERSION && \
    echo 'export PATH=$NVM_DIR/versions/node/v'$NODE_VERSION'/bin:\$PATH' >> /root/.bashrc"

# 作業ディレクトリを設定
WORKDIR /app

# デフォルトシェルをbashに設定
SHELL ["/bin/bash", "-c"]

# bashrcにnvmの設定を追加（インタラクティブシェル用）
RUN echo 'export NVM_DIR="/root/.nvm"' >> /root/.bashrc && \
    echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> /root/.bashrc && \
    echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> /root/.bashrc

# ENVでグローバルPATHを設定（コンテナ起動時用）
ENV PATH=/root/.nvm/versions/node/v22.0.0/bin:$PATH

