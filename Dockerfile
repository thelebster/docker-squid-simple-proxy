FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -yq squid curl apache2-utils

# Set default conf
RUN mv /etc/squid/squid.conf /etc/squid/squid.conf.origin && chmod a-w /etc/squid/squid.conf.origin

# Remove commented lines
RUN egrep -v "^\s*(#|$)" /etc/squid/squid.conf.origin | uniq | sort > /etc/squid/squid.conf

# Create a username/password for ncsa_auth
RUN echo 'root:iddqd' htpasswd -c -i -b /etc/squid/.htpasswd

RUN sed -i "1 i\\
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/.htpasswd\\
auth_param basic children 5\\
auth_param basic realm Squid proxy-caching web server\\
auth_param basic credentialsttl 2 hours\\
auth_param basic casesensitive off" /etc/squid/squid.conf

RUN sed -i "/http_access deny all/ i\\
acl ncsa_users proxy_auth REQUIRED\\
http_access allow ncsa_users" /etc/squid/squid.conf

# Restart Squid
RUN service squid restart

ADD entrypoint.sh /sbin/entrypoint.sh
RUN chmod +x /sbin/entrypoint.sh

EXPOSE 22 3128/tcp

ENTRYPOINT ["/sbin/entrypoint.sh"]
