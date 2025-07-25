FROM asia-northeast1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest

# Switch to root for installation
USER root

# Install Python 3.12
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.12 python3.12-pip python3.12-venv && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

# Install nvm and Node.js 22
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash && \
    export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install 22 && \
    nvm use 22 && \
    nvm alias default 22

# Install Claude CLI
RUN npm install -g @anthropic-ai/claude-cli

# Create alias for claude command to launch Claude Code
RUN echo 'alias claude="claude-cli"' >> /etc/bash.bashrc && \
    echo 'export PATH="$HOME/.nvm/versions/node/v22.*/bin:$PATH"' >> /etc/bash.bashrc

# Set environment variables for nvm
ENV NVM_DIR="/root/.nvm"
ENV PATH="$NVM_DIR/versions/node/v22.11.0/bin:$PATH"

# Switch back to the default user
USER user

# Set working directory
WORKDIR /home/user
