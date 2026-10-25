
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV HOME=/home/lab

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash curl ca-certificates git sudo \
    python3 python3-venv python3-pip \
    build-essential pkg-config \
    nano vim less file procps iproute2 iputils-ping \
    qemu-system-x86 qemu-utils \
    xz-utils unzip zip tar \
    && rm -rf /var/lib/apt/lists/*

# Install browser-based VS Code
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create the workspace and a non-root user
RUN useradd --create-home --shell /bin/bash lab \
    && mkdir -p /workspace/vms /workspace/isos \
    && chown -R lab:lab /workspace /home/lab \
    && echo 'lab ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/lab \
    && chmod 0440 /etc/sudoers.d/lab

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY vm-create.sh /usr/local/bin/vm-create
COPY vm-run.sh /usr/local/bin/vm-run
COPY vm-stop.sh /usr/local/bin/vm-stop

# Fix Windows line endings and executable permissions
RUN sed -i 's/\r$//' \
    /usr/local/bin/entrypoint.sh \
    /usr/local/bin/vm-create \
    /usr/local/bin/vm-run \
    /usr/local/bin/vm-stop \
    && chmod +x \
    /usr/local/bin/entrypoint.sh \
    /usr/local/bin/vm-create \
    /usr/local/bin/vm-run \
    /usr/local/bin/vm-stop

WORKDIR /workspace

EXPOSE 7860

ENTRYPOINT ["/bin/bash", "/usr/local/bin/entrypoint.sh"]
