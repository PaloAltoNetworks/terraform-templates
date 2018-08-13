FROM alpine:3.6

ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

RUN echo "===> Installing sudo to emulate normal OS behavior..."  && \
    apk --update add sudo                                         && \
    echo "===> Adding Python runtime..."  && \
    apk --update add python py-pip openssl ca-certificates    && \
    apk --update add --virtual build-dependencies \
                python-dev libffi-dev openssl-dev build-base  && \
    pip install --upgrade pip cffi                            && \
    echo "===> Installing Ansible..."  && \
    pip install ansible                && \
    echo "===> Installing handy tools (not absolutely required)..."  && \
    pip install --upgrade pywinrm                  && \
    apk --update add sshpass openssh-client rsync  && \
    echo "===> Removing package list..."  && \
    apk del build-dependencies            && \
    rm -rf /var/cache/apk/*               && \
    echo "===> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible                        && \
    echo 'localhost' > /etc/ansible/hosts

ENV TERRAFORM_VERSION=0.11.7
ENV TERRAFORM_SHA256SUM=6b8ce67647a59b2a3f70199c304abca0ddec0e49fd060944c26f666298e23418

RUN echo "===> Installing Terraform..."  && \
    apk add --update git curl openssh && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip  && \
    rm -f terraform_${TERRAFORM_VERSION}_SHA256SUMS


RUN echo "===> Cloning ansible-pan repo..."  && \
    git clone https://github.com/PaloAltoNetworks/ansible-pan.git  && \
    echo "===> Install PaloAltoNetworks from ansible-galaxy..."  && \
    ansible-galaxy install PaloAltoNetworks.paloaltonetworks

RUN echo "===> Copying terraform-templates reop..."  && \
    git clone https://github.com/PaloAltoNetworks/terraform-templates.git  && \
    echo "===> initializing one click AWS terraform template..."  && \
    cd /terraform-templates/one-click-multi-cloud/one-click-aws && \
    terraform init && \
    echo "===> initializing one click Azure terraform template..."  && \
    cd /terraform-templates/one-click-multi-cloud/one-click-azure  && \
    terraform init