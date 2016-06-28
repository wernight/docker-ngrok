FROM codenvy/ubuntu_jdk8

# Install Ngrok
ADD https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip /ngrok.zip
RUN set -x \
 && unzip -o ngrok.zip -d /bin \
 && rm -f /ngrok.zip