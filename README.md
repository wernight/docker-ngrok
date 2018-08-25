[![Docker repository](https://img.shields.io/docker/automated/wernight/ngrok.svg)](https://hub.docker.com/r/wernight/ngrok/) [![Build passing](https://img.shields.io/docker/build/wernight/ngrok.svg)](https://hub.docker.com/r/wernight/ngrok/) [![Codenvy badge](http://beta.codenvy.com/factory/resources/codenvy-contribute.svg)](http://beta.codenvy.com/f?url=https://github.com/wernight/docker-ngrok 'Start development on Codenvy')

# Supported tags and respective `Dockerfile` links

  * [`latest`](https://github.com/wernight/docker-ngrok/blob/master/Dockerfile) [![](https://images.microbadger.com/badges/image/wernight/ngrok.svg)](http://microbadger.com/images/wernight/ngrok "Get your own image badge on microbadger.com")
  * [`armhf`](https://github.com/wernight/docker-ngrok/blob/master/Dockerfile.armhf)

A [Docker][docker] image for [ngrok][ngrok] v2, introspected tunnels to localhost.
It's based on the excellent work of [wizardapps/ngrok][wizardapps/ngrok] and [fnichol/ngrok][fnichol/ngrok].


## Features

  * **Small**: Built using [busybox][busybox].
  * **Simple**: Just link as `http` or `https` in most cases, see below; exposes ngrok server `4040` port.
  * **Secure**: Runs as non-root user with a random UID `6737` (to avoid mapping to an existing UID).


## Configuration

To see command-line options, run `docker run --rm wernight/ngrok ngrok --help`.


## Usage

Supposing you've an Apache or Nginx Docker container named `web_service_container` listening on port 80:

    $ docker run --rm -it --link web_service_container wernight/ngrok ngrok http web_service_container:80


### Environment variables

*Please consider using directly the command-line arguments of Ngrok.*

If you use the default `CMD` (i.e. don't specify the ngrok command-line but only `wernight/ngrok`),
then you can use instead envrionment variables magic below.

You simply have to link the Ngrok container to the application under the `app` or `http` or `https` aliases, and all of the configuration will be done for you by default.

Additionally, you can specify one of several environment variable (via `-e`) to configure your Ngrok tunnel:

  * `NGROK_AUTH` - Authentication key for your Ngrok account. This is needed for custom subdomains, custom domains, and HTTP authentication.
  * `NGROK_SUBDOMAIN` - Name of the custom subdomain to use for your tunnel. You must also provide the authentication token.
  * `NGROK_HOSTNAME` - Paying Ngrok customers can specify a custom domain. Only one subdomain or domain can be specified, with the domain taking priority.
  * `NGROK_USERNAME` - Username to use for HTTP authentication on the tunnel. You must also specify an authentication token.
  * `NGROK_PASSWORD` - Password to use for HTTP authentication on the tunnel. You must also specify an authentication token.
  * `NGROK_PROTOCOL` - Can either be `HTTP` or `TCP`, and it defaults to `HTTP` if not specified. If set to `TCP`, Ngrok will allocate a port instead of a subdomain and proxy TCP requests directly to your application.
  * `NGROK_PORT` - Port to expose (defaults to `80` for `HTTP` protocol).
  * `NGROK_REGION` - Location of the ngrok tunnel server; can be `us` (United States, default), `eu` (Europe), `ap` (Asia/Pacific) or `au` (Australia)

#### Full example

 1. We'll set up a simple example HTTP server in a docker container named `www`:

        $ docker run -v /usr/share/nginx/html --name www_data busybox true
        $ docker run --rm --volumes-from www_data busybox /bin/sh -c 'echo "<h1>Yo</h1>" > /usr/share/nginx/html/index.html'
        $ docker run -d -p 80 --volumes-from www_data --name www nginx
        $ curl $(docker port www 80)
        <h1>Yo</h1>

 2. Now we'll link that HTTP server into an ngrok container to expose it on the internet:

        $ docker run -d -p 4040 --link www:http --name www_ngrok wernight/ngrok

 3. You can now access the [API][ngrok-api] to find the assigned domain:

        $ curl $(docker port www_ngrok 4040)/api/tunnels

    or access the web UI to see requests and responses:

        $ xdg-open http://$(docker port www_ngrok 4040)


### Helper

For common cases you may want to create an alias in your `~/.profile` (or `~/.bashrc`, `~/.zshrc`, or equivalent):

    function docker-ngrok() {
      docker run --rm -it --link "$1":http wernight/ngrok ngrok http http:80
    }
    # For ZSH with Oh-My-Zsh! and 'docker' plugin enabled, you can also enable auto-completion:
    #compdef __docker_containers docker-ngrok

Then to the simple example just do `docker-ngrok web_service_container`.



## Feedbacks

Report issues/questions/feature requests on [GitHub Issues][issues].

Pull requests are very welcome!

[issues]:           https://github.com/wernight/docker-ngrok/issues
[docker]:           https://www.docker.io/
[ngrok]:            https://ngrok.com/
[ngrok-api]:        https://ngrok.com/docs#client-api
[busybox]:          https://registry.hub.docker.com/_/busybox
[wizardapps/ngrok]: https://registry.hub.docker.com/u/wizardapps/ngrok/
[fnichol/ngrok]:    https://registry.hub.docker.com/u/fnichol/ngrok/
