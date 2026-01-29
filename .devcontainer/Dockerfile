# Dreamcoder DevContainer Dockerfile
# Based on Arch Linux for maximum power & freshness

FROM archlinux:base-devel

# Update & Install Core Dependencies
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm --needed \
    git \
    curl \
    wget \
    zsh \
    fish \
    neovim \
    starship \
    bat \
    eza \
    fd \
    ripgrep \
    fzf \
    zoxide \
    jq \
    stow \
    openssh \
    nodejs \
    npm \
    go \
    rust \
    unzip

# Create dev user
RUN useradd -m -s /usr/bin/zsh dreamcoder && \
    echo "dreamcoder ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/dreamcoder

USER dreamcoder
WORKDIR /home/dreamcoder

# Set up environment variables
ENV TERM=xterm-256color
ENV EDITOR=nvim
ENV LANG=en_US.UTF-8

# Pre-install plugin managers (Fisher for Fish)
RUN curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | fish -c "source && fisher install jorgebucaran/fisher"

CMD [ "zsh" ]
