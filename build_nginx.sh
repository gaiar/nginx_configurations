#!/usr/bin/env bash
# Source: http://www.htpcguides.com
# Author: drake

# Make script exit if a simple command fails and
# Make script print commands being executed
set -e -x

# names of latest versions of each package
export VERSION_PCRE=pcre-8.39
export VERSION_OPENSSL=openssl-1.1.0c
export VERSION_ZLIB=zlib-1.2.8
export VERSION_NGINX=nginx-1.10.2

# URLs to the source directories
export SOURCE_OPENSSL=https://www.openssl.org/source/
export SOURCE_PCRE=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/
export SOURCE_ZLIB=http://zlib.net/
export SOURCE_NGINX=http://nginx.org/download/

# clean out any files from previous runs of this script
rm -rf build
mkdir build

# ensure that we have the dependencies to compile nginx & modules
# make sure you have contrib non-free repository added to your sources!
apt-get update
apt-get install curl wget build-essential libexpat-dev unzip apt-utils libgeoip-dev -y

# grab the source files
wget -P ./build $SOURCE_PCRE$VERSION_PCRE.tar.gz
wget -P ./build $SOURCE_OPENSSL$VERSION_OPENSSL.tar.gz --no-check-certificate
wget -P ./build $SOURCE_ZLIB$VERSION_ZLIB.tar.gz
wget -P ./build $SOURCE_NGINX$VERSION_NGINX.tar.gz

# Create NGINX cache directories if they do not already exist
if [ ! -d "/var/cache/nginx/" ]; then
    mkdir -p \
    /var/cache/nginx/client_temp \
    /var/cache/nginx/proxy_temp \
    /var/cache/nginx/fastcgi_temp \
    /var/cache/nginx/uwsgi_temp \
    /var/cache/nginx/scgi_temp
fi

# expand the source files
cd build
tar xzf $VERSION_NGINX.tar.gz
tar xzf $VERSION_OPENSSL.tar.gz
tar xzf $VERSION_PCRE.tar.gz
tar xzf $VERSION_ZLIB.tar.gz
cd ../

# set where nginx will be built
export BPATH=$(pwd)/build

# Get nginx dav ext module for full WebDAV support
cd $BPATH/$VERSION_NGINX
wget -c https://github.com/arut/nginx-dav-ext-module/archive/master.zip -O nginx-dav-ext-module-master.zip
unzip nginx-dav-ext-module-master.zip

# build nginx, with various modules included/excluded (http_v2, full WebDAV, GeoIP, etc), SSLv3 disabled, no weak SSL ciphers.
cd $BPATH/$VERSION_NGINX
./configure \
--prefix=/etc/nginx \
--with-cc-opt='-O3 -fPIE -fstack-protector-strong -Wformat -Werror=format-security' \
--with-ld-opt='-Wl,-Bsymbolic-functions -Wl,-z,relro' \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/var/run/nginx.pid \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
--user=www-data \
--group=www-data \
--sbin-path=/usr/sbin/nginx \
--pid-path=/var/run/nginx.pid \
--with-pcre=$BPATH/$VERSION_PCRE \
--with-openssl-opt="no-weak-ssl-ciphers no-ssl3 no-shared $ECFLAG -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong" \
--with-openssl=$BPATH/$VERSION_OPENSSL \
--with-zlib=$BPATH/$VERSION_ZLIB \
--with-http_auth_request_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_mp4_module \
--with-http_realip_module \
--with-http_ssl_module \
--with-http_v2_module \
--with-file-aio \
--with-ipv6 \
--with-http_gzip_static_module \
--with-http_stub_status_module \
--with-http_geoip_module \
--with-http_dav_module \
--with-threads \
--without-mail_pop3_module \
--without-mail_smtp_module \
--without-mail_imap_module \
--add-module=$BPATH/$VERSION_NGINX/nginx-dav-ext-module-master
make
make install

# Create config files for nginx
 mkdir -p \
   /etc/nginx/sites-available \
   /etc/nginx/sites-enabled \
   /etc/nginx/snippets

# Copy nginx configuration files from Github repository
wget -O /etc/nginx/sites-available/default https://raw.githubusercontent.com/HTPCGuides/nginx_configurations/master/default

# Symlink default config file to sites-enabled
ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Create default root folder and get default index.html file
mkdir -p /var/www/html/
wget -O /var/www/html/index.html https://raw.githubusercontent.com/HTPCGuides/nginx_configurations/master/index.html

# Set user and group to nginx, and set permissions
chown -R www-data:www-data /var/www/html/
chmod -R 775 /var/www/html/

# Add proxy-control.conf and fastcgi-php.conf to snippets
wget -O /etc/nginx/snippets/proxy-control.conf https://raw.githubusercontent.com/HTPCGuides/nginx_configurations/master/proxy-control.conf
wget -O /etc/nginx/snippets/fastcgi-php.con https://raw.githubusercontent.com/HTPCGuides/nginx_configurations/master/fastcgi-php.conf

# Backup nginx.conf created with make install to nginx.conf.backup, and create fresh nginx.conf
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.backup
wget -O /etc/nginx/nginx.conf https://raw.githubusercontent.com/HTPCGuides/nginx_configurations/master/nginx.conf

# Set permissions
# chown -R www-data:www-data /etc/nginx/
chmod -R 664 /etc/nginx/

# Set /etc/nginx/ directory permission to 645, required for auth basic (don't change this, otherwise aut_basic won't work)
chmod 645 /etc/nginx/

# Remove /etc/nginx/html directory created by make install, as we use /var/www/html
rm -r /etc/nginx/html/

# Create NGINX systemd service file if it does not already exist
if [ ! -e "/lib/systemd/system/nginx.service" ]; then
  # Control will enter here if $DIRECTORY doesn't exist.
  FILE="/lib/systemd/system/nginx.service"

  /bin/cat >$FILE <<'EOF'
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target
[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true
[Install]
WantedBy=multi-user.target
EOF
fi

# Enable nginx.service
systemctl enable nginx.service

#Start nginx.service
systemctl start nginx.service

# Display detailed nginx version with enabled modules
nginx -V

echo "All done. You can now proceed to configure nginx with Let's Encrypt certifiactes and hardened security. http://www.htpcguides.com";
