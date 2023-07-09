# THE PROJECT SPECIFIC DOCKERFILE

FROM devvoid:latest

# install additional packages
#===================================================

# rust for embedded

# switch to root user
USER root

# packages
RUN xbps-install --sync -y \
  Bear \
  llvm

# toolchains/compilers
RUN xbps-install --sync -y \
  cross-arm-none-eabi-gcc

# zephyr
RUN xbps-install --sync -y \
  dtc

# RT-thread
RUN xbps-install --sync -y \
  scons

# switch back to normal user
USER ${USER}
SHELL ["/usr/bin/fish", "--login", "-c"]

# rust
RUN echo "1" | rustup-init
RUN cd ~/dotfiles && stow --verbose --no-folding -R cargo

# c2rust
RUN ~/.cargo/bin/cargo install c2rust

ENTRYPOINT ["fish"]
