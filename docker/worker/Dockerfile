## INITIAL SETUP

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install SSH server
RUN apt-get update && apt-get install -y \
    openssh-server \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /var/run/sshd

# Create slurm user with consistent UID across all nodes
RUN groupadd -g 1001 slurm \
    && useradd -m -u 1001 -g slurm -s /bin/bash slurm \
    && echo 'slurm:slurm' | chpasswd

# Configure SSH so ansible can connect w/out SSH keys
## Not reflective of what you'd want in a production env
## TODO: Use SSH keys and disable root login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Set root password for debugging
RUN echo 'root:root' | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
