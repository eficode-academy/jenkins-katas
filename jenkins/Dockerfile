FROM jenkinsci/blueocean
USER root
RUN apk add py-pip python-dev libffi-dev openssl-dev gcc libc-dev make && pip install docker-compose
USER jenkins
RUN /usr/local/bin/install-plugins.sh swarm:3.17