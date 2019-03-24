FROM resin/raspberrypi3-alpine

RUN [ "cross-build-start" ]

RUN set -x \
    # Install ngrok (latest official stable from https://ngrok.com/download).
 && apk add --no-cache curl \
 && curl -Lo /ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-arm.zip \
 && unzip -o /ngrok.zip -d /bin \
 && rm -f /ngrok.zip \
    # Create non-root user.
 && adduser -h /home/ngrok -D -u 6737 ngrok

# Add config script.
COPY --chown=ngrok ngrok.yml /home/ngrok/.ngrok2/
COPY entrypoint.sh /

RUN [ "cross-build-end" ]

USER ngrok
ENV USER=ngrok

EXPOSE 4040

CMD ["/entrypoint.sh"]
