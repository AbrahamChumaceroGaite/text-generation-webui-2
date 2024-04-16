# BUILDER
FROM ubuntu:22.04
WORKDIR /builder
ARG TORCH_CUDA_ARCH_LIST="${TORCH_CUDA_ARCH_LIST:-3.5;5.0;6.0;6.1;7.0;7.5;8.0;8.6+PTX}"
ARG BUILD_EXTENSIONS="${BUILD_EXTENSIONS:-}"
ARG APP_UID="${APP_UID:-6972}"
ARG APP_GID="${APP_GID:-6972}"

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked,rw \
    apt update && \
    apt install --no-install-recommends -y git vim build-essential python3-dev pip bash curl && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /home/app/
RUN git clone https://github.com/oobabooga/text-generation-webui.git
WORKDIR /home/app/text-generation-webui
RUN GPU_CHOICE=A USE_CUDA118=FALSE LAUNCH_AFTER_INSTALL=FALSE INSTALL_EXTENSIONS=TRUE ./start_linux.sh --verbose
WORKDIR /home/app/text-generation-webui

RUN apt update -y && apt install -y socat
RUN echo '--api --listen --listen-port 3001' > CMD_FLAGS.txt


# Default to API port 5000. Can be overridden at runtime.
ENV IPV4_PORT 80
ENV IPV6_PORT 3000
# set umask to ensure group read / write at runtime
CMD /bin/bash -c "umask 0002 && export HOME=/home/app/text-generation-webui && ./start_linux.sh & socat TCP6-LISTEN:${IPV6_PORT},fork TCP4:0.0.0.0:80"
