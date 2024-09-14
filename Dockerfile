FROM debian:bookworm-slim

# Install required packages without recommended extras
RUN apt-get update -q \
    && apt-get install -yq --no-install-recommends \
        git \
        unzip \
        curl \
        gettext \
        zsh \
        wget \
        neovim \
        gettext-base \
        openssh-client \
        ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Define user and group ID, along with the username and home directory
ARG UID=1000
ARG GID=$UID
ARG USER=me
ARG HOME=/home/${USER}

# Create a new user and group, set bash as the default shell for now
RUN groupadd -g ${GID} ${USER} \
    && useradd -m -u ${UID} -g ${USER} -s /bin/bash ${USER} \
    && mkdir ${HOME}/workspace \
    && chown -R ${USER}:${USER} ${HOME}

# Copy the custom .zshrc
COPY .zshrc ${HOME}/.zshrc
RUN chown ${USER}:${USER} ${HOME}/.zshrc

# Switch to the new user
USER ${USER}
WORKDIR ${HOME}

# Install oh my zsh
RUN wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - | ZSH=${HOME}/.oh-my-zsh RUNZSH=no KEEP_ZSHRC=yes bash && \
    chown -R ${USER}:${USER} ${HOME}/.oh-my-zsh

ENTRYPOINT ["/bin/zsh", "-i"]

