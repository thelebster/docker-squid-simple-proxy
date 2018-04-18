#!/bin/bash
set -e

mkdir -p /var/log/squid
chmod -R 755 /var/log/squid
chown -R proxy:proxy /var/log/squid

sed -i "1 i\\
auth_param basic program /usr/lib/squid/basic_ncsa_auth /etc/squid/.htpasswd\\
auth_param basic children 5\\
auth_param basic realm Squid proxy-caching web server\\
auth_param basic credentialsttl 2 hours\\
auth_param basic casesensitive off" /etc/squid/squid.conf

sed -i "/http_access deny all/ i\\
acl ncsa_users proxy_auth REQUIRED\\
http_access allow ncsa_users" /etc/squid/squid.conf

# allow arguments to be passed to squid3
if [[ ${1:0:1} = '-' ]]; then
  EXTRA_ARGS="$@"
  set --
elif [[ ${1} == squid3 || ${1} == $(which squid) ]]; then
  EXTRA_ARGS="${@:2}"
  set --
fi

# default behaviour is to launch squid
if [[ -z ${1} ]]; then
  echo "Starting squid..."
  exec $(which squid) -f /etc/squid/squid.conf -NYCd 1 ${EXTRA_ARGS}
else
  exec "$@"
fi
