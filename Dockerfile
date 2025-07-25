FROM asia-northeast1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest

# Switch to root for installation
USER root

# Install Python 3.12 (Ubuntu 24.04 already has Python 3.12)
RUN apt-get update && \
    apt-get install -y python3.12 python3.12-venv python3.12-dev && \
    apt-get install -y python3-pip && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.12 1

# Install nvm and Node.js 22
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash && \
    export NVM_DIR="/root/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    nvm install 22 && \
    nvm use 22 && \
    nvm alias default 22

# Install Claude CLI
RUN export NVM_DIR="/root/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    npm install -g @anthropic-ai/claude-code

# Switch back to the default user
USER user

# Set working directory
WORKDIR /home/user
