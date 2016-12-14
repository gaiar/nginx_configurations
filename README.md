Script to build latest stable nginx with static OpenSSL, PCRE, ZLIB for ARM based devices. Tested on Debian 8 (Jessie), and Raspberry Pi running Minibian, Raspbian. Since the official nginx repository doesn't provide ARM build, it is highly advised to build the latest nginx on ARM devices and don't use the outdated version in the Debian repository.

The nginx version included in default Debian repository is very outdated (even lacks http v2), a secure nginx configuration is not possible with Let's Encrypt certificates to get an A+ (or at least an A) rating on Quallys SSL Labs. You must build nginx from source.

This scripts will:

-- install the required dependencies

-- download binaries for nginx, OpenSSL, PCRE, ZLIB, extra nginx modules

-- add nginx modules to have GeoIP, full WebDAV supports (included third party module dav-ext) required for example for ownCloud

-- set nginx to be run as user www-data, keeping compatibility with php

-- create and enable the systemd unit file for nginx (nginx.service)

-- create required default configuration files for nginx (inluding the nginx.conf, default, snippets proxy-control.conf, fastcgi-php.conf)

-- create default index.html and set root location at /var/www/html/


This script is useful if you would like to create a very secure nginx setup with Let's Encrypt certificates. The full guide is located at HTPCGuides: http://www.htpcguides.com/secure-nginx-reverse-proxy-with-lets-encrypt-on-ubuntu-16-04-lts/

Important: you should build nginx if you are using ARM device like Raspberry Pi, based on Debian 8 (Minibian, OSMC, Raspbian). On Ubuntu just add the official nginx PPA, and install nginx-extras (you need extras if you need full WebDAV support). Debain on X64/86 sytems can use the official nginx repository, you don't need to build from source (check if nginx-extras are available).

***
You need to add the Debian contrib and non-free components to your apt sources:

echo "deb http://httpredir.debian.org/debian jessie main contrib non-free" >> /etc/apt/sources.list.d/deb-contribnonfree.list

echo "deb-src http://httpredir.debian.org/debian jessie main contrib non-free" >> /etc/apt/sources.list.d/deb-contribnonfree.list

echo "deb http://httpredir.debian.org/debian jessie-updates main contrib non-free" >> /etc/apt/sources.list.d/deb-contribnonfree.list

echo "deb-src http://httpredir.debian.org/debian jessie-updates main contrib non-free" >> /etc/apt/sources.list.d/deb-contribnonfree.list

If you run apt-get update and you recevive a GPG error that a public key is not availble, then first install

apt-get install debian-keyring

and do and update. If you still receive the error after update, then install

apt-get install debian-archive-keyring

***

This script is loosely based on work by Matt Wilcox https://gist.github.com/MattWilcox/402e2e8aa2e1c132ee24 and a fork by Matthew Vance https://gist.github.com/MatthewVance/dcc377523ca1b1159ded
