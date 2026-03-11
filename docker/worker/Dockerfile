## INITIAL SETUP

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Installing SSH server
RUN apt-get update && apt-get install -y \
    openssh-server \
    iputils-ping 

# Required for sshd
RUN mkdir /var/run/sshd

# Slurm user (UID 1001)
RUN groupadd -g 1001 slurm \
    && useradd -m -u 1001 -g slurm -s /bin/bash slurm \
    && echo 'slurm:password' | chpasswd

# Munge user (UID 999)
RUN groupadd -g 999 munge \
    && useradd -r -u 999 -g munge -s /sbin/nologin munge

# Ansible user (passwordless sudo for automation)
RUN apt-get install -y sudo \
    && useradd -m -s /bin/bash ansible \
    && echo 'ansible:ansible' | chpasswd \
    && echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible \
    && chmod 0440 /etc/sudoers.d/ansible

# Configuring SSH so ansible can connect w/out SSH keys
## Not reflective of what you'd want in a production env
## TODO: Use SSH keys and disable root login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Root password for debugging
RUN echo 'root:root' | chpasswd

## MUNGE
# Authentication service for SLURM
RUN apt-get install -y munge

# Cleanup apt-get update list:
RUN rm -rf /var/lib/apt/lists/* \

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
