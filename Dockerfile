FROM amazonlinux:2 AS core

# Set environment
ENV NODE_VERSION=14.15.0
ENV BASH_ENV="~/.bashrc"
SHELL ["/bin/bash", "-c"]

RUN yum -y update
RUN yum -y install curl git openssl tar unzip
RUN yum -y install awscli

# Get NVM (Node Version Manager, required to install Node)
RUN echo "# Placeholder for npm" >> ~/.bashrc
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash

# Install Node (AWS Amplify requirement)
RUN nvm install $NODE_VERSION
RUN nvm use $NODE_VERSION
RUN nvm alias default node
RUN nvm cache clear

# Install AWS Amplify
RUN npm install -g @aws-amplify/cli --verbose

# Set environment
RUN echo "nvm use ${NODE_VERSION} 1> /dev/null" >> ~/.bashrc

ENTRYPOINT [ "bash" ]