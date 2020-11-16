FROM amazonlinux:2 AS core

# Arguments
ARG NAME="John Doe"
ARG EMAIL="john.doe@company.com"

# Set environment
ENV NODE_VERSION=14.15.0
ENV BASH_ENV="~/.bashrc"
SHELL ["/bin/bash", "-c"]

RUN yum -y update
RUN yum -y install curl git openssl tar unzip
RUN yum -y install awscli

# Set up name/email for Git
RUN echo "# Placeholder for npm" > ~/.bashrc
RUN echo "export EMAIL_ADDRESS='${EMAIL}'" >> ~/.bashrc
RUN echo "export REAL_NAME='${NAME}'" >> ~/.bashrc
RUN git config --global user.email "${EMAIL}"
RUN git config --global user.name "${NAME}"

# Get NVM (Node Version Manager, required to install Node)
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash

# Install Node (AWS Amplify requirement)
RUN nvm install $NODE_VERSION
RUN nvm use $NODE_VERSION
RUN nvm alias default node
RUN nvm cache clear
RUN echo "nvm use ${NODE_VERSION} 1> /dev/null" >> ~/.bashrc

# Install AWS Amplify
RUN npm install -g @aws-amplify/cli --verbose

# Install Angular
RUN npm install -g @angular/cli

# Open up ports to host machine shared by Angular
EXPOSE 4200/tcp

# Allow mounting .aws directory to avoid setting up new authentication with AWS.
RUN mkdir -p ~/.aws
VOLUME ~/.aws

# Python 3.8 (for Lambda and other AWS coding)
RUN yum -y install amazon-linux-extras
RUN amazon-linux-extras enable python3.8
RUN yum -y install python3.8

# Python 3.8 / 2.7 as default Python to use. AL2 uses Python 2.7 out of the box.
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3.8 2
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1

# Python versions in use and default
# RUN update-alternatives --list | grep python
# RUN python -V

ENTRYPOINT [ "bash" ]

# For manual steps after this, refer to README.md

