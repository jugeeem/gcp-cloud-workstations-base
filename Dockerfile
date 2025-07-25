FROM asia-northeast1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest

# ユーザーをrootに切り替え
USER root

# システムパッケージの更新とPython 3.13のインストール
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
    liblzma-dev && \
    rm -rf /var/lib/apt/lists/*

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

# Claude Code用の前提条件をインストール
RUN python -m pip install \
    requests \
    anthropic \
    openai \
    python-dotenv \
    jupyter \
    ipykernel \
    notebook \
    jupyterlab

# VS Code拡張機能のインストール用ディレクトリ作成
RUN mkdir -p /opt/code-server/extensions

# Pythonサポート用のVS Code拡張機能をプリインストール
# （Cloud Workstations環境では手動でインストールする必要がある場合があります）
RUN curl -L https://marketplace.visualstudio.com/_apis/public/gallery/publishers/ms-python/vsextensions/python/latest/vspackage -o /tmp/python-extension.vsix

# 作業ディレクトリの作成
RUN mkdir -p /home/user/workspace && \
    chown -R user:user /home/user/workspace

# Claude Code用の設定ファイルテンプレート作成
RUN mkdir -p /home/user/.config/claude-code && \
    echo '# Claude Code Configuration Template' > /home/user/.config/claude-code/config.example && \
    echo '# Please set your API key after starting the workstation' >> /home/user/.config/claude-code/config.example && \
    echo 'ANTHROPIC_API_KEY=your_api_key_here' >> /home/user/.config/claude-code/config.example && \
    chown -R user:user /home/user/.config

# userに権限を戻す
USER user

# 環境変数の設定
ENV PYTHON_VERSION=3.13
ENV PATH="/usr/local/bin:${PATH}"

# デフォルトの作業ディレクトリ
WORKDIR /home/user/workspace

# ヘルスチェック
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD python --version || exit 1
