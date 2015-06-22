#!/bin/sh

if [ "$1" = "/bin/sh" ]; then
  shift
fi

if [ -n "$HTTPS_PORT" ]; then
  FWD="`echo $HTTPS_PORT | sed 's|^tcp://||'`"
elif [ -n "$HTTP_PORT" ]; then
  FWD="`echo $HTTP_PORT | sed 's|^tcp://||'`"
elif [ -n "$APP_PORT" ]; then
  FWD="`echo $APP_PORT | sed 's|^tcp://||'`"
fi

ARGS=""

if [ -n "$NGROK_AUTH" ]; then
  ARGS="-authtoken=$NGROK_AUTH "
fi

# Set the subdomain or hostname, depending on which is set
if [ -n "$NGROK_HOSTNAME" ] && [ -n "$NGROK_AUTH" ]; then
  ARGS="$ARGS -hostname=$NGROK_HOSTNAME "
elif [ -n "$NGROK_SUBDOMAIN" ] && [ -n "$NGROK_AUTH" ]; then
  ARGS="$ARGS -subdomain=$NGROK_SUBDOMAIN "
elif [ -n "$NGROK_HOSTNAME" ] || [ -n "$NGROK_SUBDOMAIN" ]; then
  if [ -z "$NGROK_AUTH" ]; then
        echo "You must specify an authentication token after registering at https://ngrok.com to use custom domains."
    exit 1
  fi
fi

if [ -n "$NGROK_HEADER" ]; then
  ARGS="$ARGS -host-header=$NGROK_HEADER "
fi

PROTOCOL="http"

if [ "$NGROK_PROTOCOL" == "TCP" ]; then
  PROTOCOL="tcp "
fi

if [ -n "$NGROK_USERNAME" ] && [ -n "$NGROK_PASSWORD" ] && [ -n "$NGROK_AUTH" ]; then
  ARGS="$ARGS -auth=\"$NGROK_USERNAME:$NGROK_PASSWORD\" "
elif [ -n "$NGROK_USERNAME" ] || [ -n "$NGROK_PASSWORD" ]; then
  if [ -z "$NGROK_AUTH" ]; then
        echo "You must specify a username, password, and Ngrok authentication token to use the custom HTTP authentication."
    echo "Sign up for an authentication token at https://ngrok.com"
    exit 1
  fi
fi

case "$1" in
  -h|help)  ARGS=$1 ;;
  *)        ARGS="$PROTOCOL $ARGS -log stdout $* $FWD" ;;
esac

exec /bin/ngrok $ARGS
