FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -yq squid curl apache2-utils

# Set default conf
RUN mv /etc/squid/squid.conf /etc/squid/squid.conf.origin && chmod a-w /etc/squid/squid.conf.origin

# Remove commented lines
RUN egrep -v "^\s*(#|$)" /etc/squid/squid.conf.origin | uniq | sort > /etc/squid/squid.conf

# Create a username/password for ncsa_auth
RUN htpasswd -c -i -b /etc/squid/.htpasswd doom iddqd

ADD entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

EXPOSE 22 3128/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]
