FROM asia-northeast1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest

# ユーザーをrootに切り替え
USER root

# システムパッケージの更新
RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    wget \
    curl \
    git \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    ca-certificates \
    gnupg \
    lsb-release && \
    rm -rf /var/lib/apt/lists/*

# Node.js 20 LTS（最新安定版）のインストール
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# npmとyarnの最新版をインストール
RUN npm install -g npm@latest && \
    npm install -g yarn pnpm

# Python 3.13のソースからのビルドとインストール
RUN cd /tmp && \
    wget https://www.python.org/ftp/python/3.13.0/Python-3.13.0.tgz && \
    tar xzf Python-3.13.0.tgz && \
    cd Python-3.13.0 && \
    ./configure --enable-optimizations --with-ensurepip=install && \
    make -j $(nproc) && \
    make altinstall && \
    cd / && \
    rm -rf /tmp/Python-3.13.0*

# Python 3.13をデフォルトのpythonとして設定
RUN update-alternatives --install /usr/bin/python python /usr/local/bin/python3.13 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/local/bin/python3.13 1 && \
    update-alternatives --install /usr/bin/pip pip /usr/local/bin/pip3.13 1 && \
    update-alternatives --install /usr/bin/pip3 pip3 /usr/local/bin/pip3.13 1

# pipのアップグレード
RUN python -m pip install --upgrade pip

# Python環境の基本パッケージ
RUN python -m pip install \
    requests \
    python-dotenv \
    jupyter \
    ipykernel \
    notebook \
    jupyterlab

# Node.js用のClaude Code関連パッケージのグローバルインストール
RUN npm install -g \
    @anthropic-ai/sdk \
    typescript \
    ts-node \
    nodemon \
    @types/node \
    eslint \
    prettier

# 作業ディレクトリの作成
RUN mkdir -p /home/user/workspace && \
    mkdir -p /home/user/.config/claude-code && \
    chown -R user:user /home/user/workspace /home/user/.config

# Claude Code用のNode.js設定ファイルテンプレート作成
COPY --chown=user:user claude-code-setup /home/user/.config/claude-code/

# 開発に便利なツールのインストール
RUN python -m pip install \
    black \
    flake8 \
    mypy \
    pytest \
    pre-commit \
    poetry

# userに権限を戻す
USER user

# Node.jsプロジェクトの初期化用スクリプト
RUN echo '#!/bin/bash\n\
echo "Initializing Claude Code Node.js environment..."\n\
cd /home/user/workspace\n\
if [ ! -f package.json ]; then\n\
  npm init -y\n\
  npm install @anthropic-ai/sdk dotenv\n\
  npm install -D @types/node typescript ts-node nodemon\n\
fi\n\
echo "Environment ready! You can now configure your Anthropic API key."\n\
' > /home/user/.config/claude-code/init-nodejs.sh && \
chmod +x /home/user/.config/claude-code/init-nodejs.sh

# 環境変数の設定
ENV NODE_VERSION=20
ENV PYTHON_VERSION=3.13
ENV PATH="/usr/local/bin:${PATH}"

# デフォルトの作業ディレクトリ
WORKDIR /home/user/workspace

# ヘルスチェック
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node --version && python --version || exit 1
