FROM ubuntu:latest

MAINTAINER kramos <markosrendell@gmail.com>

# Install cloud foundry cli
RUN apt-get update -y && \
    apt-get install -y curl && \
    curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar xzv -C /usr/local/bin cf

# Install the cloud foundry autopilot plugin
RUN export LATEST_RELEASE_URL=$(curl -s https://github.com/contraband/autopilot/releases | grep "contraband/autopilot/releases/download" | grep linux | head -n 1 | cut -d '"' -f 2) &&\
    curl -s -L https://github.com/${LATEST_RELEASE_URL} -o /usr/local/bin/autopilot-linux && \
    chmod +x /usr/local/bin/autopilot-linux
    cf install-plugin /usr/local/bin/autopilot-linux -f

# Install the cloud foundry antifreeze plugin
RUN export LATEST_RELEASE_URL=$(curl -s https://github.com/odlp/antifreeze/releases | grep "odlp/antifreeze/releases/download" | grep linux | head -n 1 | cut -d '"' -f 2) &&\
    curl -s -L https://github.com/${LATEST_RELEASE_URL} -o /usr/local/bin/antifreeze-linux && \
    chmod +x /usr/local/bin/antifreeze-linux
    cf install-plugin /usr/local/bin/antifreeze-linux -f

COPY cf_deploy.sh /usr/local/bin

CMD cf -v
