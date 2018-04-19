# Minimal Squid as a Proxy

## Quick instructions:

```bash
docker run --name squid_proxy -d --restart=always --publish 3128:3128 -p 2222:22 --volume /var/spool/squid thelebster/docker-squid-simple-proxy
```

## Run Squid with a basic HTTP authentication

We are going to use "ncsa_auth" that allows Squid to read and authenticate user and password information from an NCSA httpd-style password file when using basic HTTP authentication.

```bash
docker run --name squid_proxy -d --restart=always --publish 3128:3128 -p 2222:22 -e SQUID_USER=qwerty -e SQUID_PASS=iddqd --volume /var/spool/squid thelebster/docker-squid-simple-proxy
```
