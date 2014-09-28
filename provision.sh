#!/bin/sh

set -e

sed -i 's,http:[^ ]*,mirror://mirrors.ubuntu.com/mirrors.txt,' /etc/apt/sources.list

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -yy apache2 vim iptables-persistent

a2enmod cgi
service apache2 restart

rsync -a /vagrant/gatekeeper.cgi /usr/lib/cgi-bin/
chmod 0755 /usr/lib/cgi-bin/gatekeeper.cgi

rsync -a /vagrant/gatekeeper.sudo /etc/sudoers.d/gatekeeper
chown -h root:root /etc/sudoers.d/gatekeeper
chmod 0440 /etc/sudoers.d/gatekeeper

rsync -a /vagrant/iptables.* /usr/local/bin/
chown -h root:www-data /usr/local/bin/iptables.*
chmod 0750 /usr/local/bin/iptables.*

sed -i '/www-data/d' /etc/at.deny

rsync -a /vagrant/iptables /etc/iptables/rules.v4
chown -h root:root /etc/iptables/rules.v4
chmod 0644 /etc/iptables/rules.v4
service iptables-persistent reload
