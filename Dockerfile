# Note: The newer busybox:glibc is missing libpthread.so.0.
FROM busybox:ubuntu-14.04
MAINTAINER Werner Beroux <werner@beroux.com>

# Install ngrok
ADD https://dl.ngrok.com/ngrok_2.0.19_linux_amd64.zip /ngrok.zip
RUN set -x \
 && unzip -o ngrok.zip -d /bin \
 && rm -f /ngrok.zip

# Add config script
COPY ngrok.yml /home/ngrok/.ngrok2/
COPY entrypoint.sh /

# Create non-root user
RUN echo 'ngrok:x:6737:6737:Ngrok user:/home/ngrok:/bin/false' >> /etc/passwd
RUN echo 'ngrok:x:6737:' >> /etc/group
RUN chown ngrok:ngrok /home/ngrok
RUN chmod -R go=u,go-w /home/ngrok
RUN chmod go= /home/ngrok

USER ngrok

EXPOSE 4040

CMD ["/entrypoint.sh"]
