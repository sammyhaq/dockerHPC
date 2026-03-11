## INITIAL SETUP

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Installing SSH server
RUN apt-get update && apt-get install -y \
    openssh-server \
    iputils-ping

# Required for sshd
RUN mkdir /var/run/sshd

# Slurm user
RUN groupadd -g 1001 slurm \
    && useradd -m -u 1001 -g slurm -s /bin/bash slurm \
    && echo 'slurm:password' | chpasswd

# Ansible user (passwordless sudo for automation)
RUN apt-get install -y sudo \
    && useradd -m -s /bin/bash ansible \
    && echo 'ansible:ansible' | chpasswd \
    && echo 'ansible ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ansible \
    && chmod 0440 /etc/sudoers.d/ansible

# Configure SSH so ansible can connect w/out SSH keys
## Not reflective of what you'd want in production env  
## TODO: use SSH keys and disable root login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Set root password for debugging
RUN echo 'root:root' | chpasswd

## ANSIBLE
# Ansible is only needed on the controller node.

# Not needed to really be split from line 8, but for compartmentalization's sake:
RUN apt-get install -y \
    ansible \
    sshpass


# Cleanup apt-get update list:
RUN rm -rf /var/lib/apt/lists/*

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
