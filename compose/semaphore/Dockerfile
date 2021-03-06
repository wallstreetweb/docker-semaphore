FROM debian:jessie

RUN groupadd -g 10000 webserver && \
    useradd -m -g webserver webserver -u 10000 && \
    apt-get update && apt-get install --no-install-recommends -y git \
    openssh-client \
    python-dev \
    libffi-dev \
    libssl-dev \
    gcc \
    ca-certificates \
    python-dev \
    rsync \
    curl \
    rxvt-unicode  \
    python-minimal \
    nano && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    ln -s /home/webserver/ansible /etc/ansible && \
    curl https://bootstrap.pypa.io/get-pip.py | python && \
    pip install virtualenv && \
    rm /bin/sh && \
    ln -s /bin/bash /bin/sh && \
    mkdir -p /home/webserver/.ssh/

ARG ANSIBLE_VERSION=2.1.1

RUN virtualenv --no-site-packages /home/webserver/defaultenv && \
    mkdir /docker-entrypoint-initdb.d && \
    /home/webserver/defaultenv/bin/pip install ansible==${ANSIBLE_VERSION} && \
    echo "export TERM=rxvt-unicode" >> /home/webserver/.bashrc && \
    echo "source /home/webserver/defaultenv/bin/activate" >> /home/webserver/.bashrc && \
    ln -s /home/webserver/defaultenv/bin/ansible /usr/bin/ansible && \
    ln -s /home/webserver/defaultenv/bin/ansible-playbook /usr/bin/ansible-playbook

WORKDIR /home/webserver
RUN mkdir -p ansible/{playbooks,roles,files} && \
    touch ansible/hosts

COPY ./ansible.cfg ansible/

RUN chown -R webserver:webserver /home/webserver
USER webserver

WORKDIR /home/webserver/ansible

VOLUME ["/home/webserver/ansible"]
VOLUME ["/home/webserver/.ssh"]

USER root
ARG SEMAPHORE_VERSION=2.0.4
ADD https://github.com/ansible-semaphore/semaphore/releases/download/v${SEMAPHORE_VERSION}/semaphore_linux_amd64 /usr/bin/semaphore
RUN chmod +x /usr/bin/semaphore && \
    mkdir /tmp/semaphore && \
    chown webserver:webserver /tmp/semaphore

COPY ./docker-entrypoint.sh /
COPY ./semaphore.sh /docker-entrypoint-initdb.d/
USER webserver

ENV GIN_MODE release
WORKDIR /home/webserver
EXPOSE 3000

USER root
COPY ./ssh_config /root/.ssh/config
RUN chmod 700 /root/.ssh/

ENTRYPOINT /docker-entrypoint.sh
#ENTRYPOINT ["/docker-entrypoint-initdb.d/semaphore.sh"]
