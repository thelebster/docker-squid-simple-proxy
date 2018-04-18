# Minimal Squid as a Transparent Proxy

Quick instructions:

```bash
docker run --name squid_proxy -d --restart=always --publish 3128:3128 -p 2222:22 --volume /var/spool/squid thelebster/docker-squid-transparent-proxy
```

```bash
docker logs --tail 50 --follow --timestamps squid_proxy
```

```bash
docker exec -it squid_proxy bash
```
