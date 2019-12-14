#########################################################################
# File Name: php_install.sh
# Version: 1.0.0
# Author: momon 
# mail: 396385090@qq.com
# Created Time: Wed 18 Jan 2017 06:23:56 AM PST
# Brief: 版本仅支持centos操作系统
#        支持PHP7.0.14,以及PHP7下扩展安装,扩展列表见packages。
#        PHP.INI相关扩展需要手动添加
#        不支持MYSQL安装
# Usage: sh php_install.sh [options]
#  -init            云端下载所有安装包
#  -nginx           安装nginx
#  -php7            安装php7
#  -php-ext         安装PHP7 扩展
#  -mysql-server    安装Mysql服务端
#  -mysql-client    安装Mysql客户端
#
# Packages: 
#  -google-perftools-1.6.tar.gz
#  -libevent-2.0.22-stable.tar.gz
#  -libiconv-1.13.1.tar.gz
#  -libmcrypt-2.5.8.tar.gz
#  -libmemcached-1.0.9.tar.gz
#  -libunwind-0.99.tar.gz
#  -m9php-php7.tar.gz
#  -mcrypt-2.6.8.tar.gz
#  -memcache-3.0.8.tgz
#  -memcached-1.4.34.tar.gz
#  -mhash-0.9.9.9.tar.gz
#  -nginx-1.11.6.tar.gz
#  -pcre-8.38.tar.gz
#  -pecl-memcache-php7.tar.gz
#  -php-5.5.38.tar.gz
#  -php-5.6.29.tar.gz
#  -php-7.0.14.tar.gz
#  -php-memcached-master.tar.gz
#  -phpredis-develop.tar.gz
#  -protobuf-master.tar.gz
#########################################################################
#!/bin/bash
NGINX_DIR="/usr/local/nginx"
PHP_DIR7="/usr/local/php7"
PHP_DIR5="/usr/local/php5"
MYSQL_DIR="/usr/local/mysql"
MEMCACHE_DIR="/usr/local/memcache"
function init()
{
LANG=C
yum -y install wget gcc gcc-c++ autoconf libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel openldap openldap-devel nss_ldap openldap-clients openldap-servers libevent-devel
read -p "Now,will download nginxphp software...Y|y:" nginxphp
case "$nginxphp" in
Y|y)
echo -n "staring download nginx php..."
cat > list << "EOF" &&
google-perftools-1.6.tar.gz
libevent-2.0.22-stable.tar.gz
libiconv-1.13.1.tar.gz
libmcrypt-2.5.8.tar.gz
libmemcached-1.0.9.tar.gz
libunwind-0.99.tar.gz
m9php-php7.tar.gz
mcrypt-2.6.8.tar.gz
memcache-3.0.8.tgz
memcached-1.4.34.tar.gz
mhash-0.9.9.9.tar.gz
nginx-1.11.6.tar.gz
pcre-8.38.tar.gz
pecl-memcache-php7.tar.gz
php-5.5.38.tar.gz
php-5.6.29.tar.gz
php-7.0.14.tar.gz
php-memcached-master.tar.gz
phpredis-develop.tar.gz
protobuf-master.tar.gz
EOF
mkdir packages
for i in `cat list`
do
    if [ -s packages/$i]; then
        echo "$i [found]"
    else
    echo "Error: $i not found!!!download now..."
    #wget http://www.imomon.com:8100/$i -P packages/
    fi
done
;;
*)
    echo -n "exit install script"
    exit 0
;;
esac
groupadd www && useradd www -s /sbin/nologin -g www
groupadd mysql && useradd mysql -s /sbin/nologin -g mysql
echo "www and mysql user && group create!"
/bin/rm -rf list
echo -e "ALL of installed sucussfull!";
}

function is_version()
{
if [ `uname -m` == "x86_64" ];then
    tar zxf libunwind-0.99.tar.gz
    tar zxvf libunwind-0.99.tar.gz
    cd libunwind-0.99/
    CFLAGS=-fPIC ./configure
    make CFLAGS=-fPIC
    make CFLAGS=-fPIC install
    cd ../
else
    echo "Your system is 32bit, not install libunwind lib!"
fi
}

function php7()
{
    cd packages/
    tar zxf libiconv-1.13.1.tar.gz
    cd libiconv-1.13.1/
    ./configure --prefix=/usr/local
    make
    make install
    cd ../
    tar zxf libmcrypt-2.5.8.tar.gz
    cd libmcrypt-2.5.8/
    ./configure
    make
    make install
    /sbin/ldconfig
    cd libltdl/
    ./configure --enable-ltdl-install
    make
    make install
    cd ../../
    tar zxf mhash-0.9.9.9.tar.gz
    cd mhash-0.9.9.9
    ./configure
    make
    make install
    cd ../
    ln -s /usr/local/lib/libmcrypt.la /usr/lib/libmcrypt.la
    ln -s /usr/local/lib/libmcrypt.so /usr/lib/libmcrypt.so
    ln -s /usr/local/lib/libmcrypt.so.4 /usr/lib/libmcrypt.so.4
    ln -s /usr/local/lib/libmcrypt.so.4.4.8 /usr/lib/libmcrypt.so.4.4.8
    ln -s /usr/local/lib/libmhash.a /usr/lib/libmhash.a
    ln -s /usr/local/lib/libmhash.la /usr/lib/libmhash.la
    ln -s /usr/local/lib/libmhash.so /usr/lib/libmhash.so
    ln -s /usr/local/lib/libmhash.so.2 /usr/lib/libmhash.so.2
    ln -s /usr/local/lib/libmhash.so.2.0.1 /usr/lib/libmhash.so.2.0.1
    ln -s /usr/local/bin/libmcrypt-config /usr/bin/libmcrypt-config
    tar zvxf mcrypt-2.6.8.tar.gz
    cd mcrypt-2.6.8
    /sbin/ldconfig
    ./configure
    make
    make install
    useradd -g www -s /sbin/nologin -M www
    cd ../
    tar zvxf php-7.0.14.tar.gz
    cd php-7.0.14
    ./configure --prefix=${PHP_DIR7} --with-config-file-path=${PHP_DIR7}/etc --enable-fpm  --enable-pcntl --enable-mysqlnd --enable-opcache --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-shmop --enable-zip --enable-ftp --enable-soap --enable-xml --enable-mbstring --disable-rpath
    --disable-debug --disable-fileinfo --with-mysqli --with-pdo-mysql --with-pcre-regex --with-iconv --with-zlib --with-mcrypt --with-gd --with-openssl --with-mhash --with-xmlrpc --with-curl --without-pear --enable-fileinfo --with-imap-ssl
    make ZEND_EXTRA_LIBS='-liconv'
    make install
    #cp php.ini /usr/local/php52/etc/
    #cp php-fpm.conf /usr/local/php52/etc/
    cp ./php.ini-development ${PHP_DIR7}/etc/php.ini
    cp ${PHP_DIR7}/etc/php-fpm.conf.default ${PHP_DIR7}/etc/php-fpm.conf
    cp ${PHP_DIR7}/etc/php-fpm.d/www.conf.default ${PHP_DIR7}/etc/php-fpm.d/www.conf
    cp -R ./sapi/fpm/php-fpm /etc/init.d/php-fpm7
    cd ..
    /sbin/ldconfig
    echo "php7 install successfully!"
}

function php5()
{
    cd packages/
    tar zxf libmcrypt-2.5.8.tar.gz
    cd libmcrypt-2.5.8/
    ./configure
    make
    make install
    /sbin/ldconfig
    cd libltdl/
    ./configure --enable-ltdl-install
    make
    make install
    cd ../../
    tar zvxf php-5.5.38.tar.gz
    cd php-5.5.38
    ./configure --prefix=${PHP_DIR5} --with-config-file-path=${PHP_DIR5}/etc --enable-opcache=no --enable-inline-optimization --disable-debug --disable-rpath --enable-shared --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-gettext --enable-mbstring --with-iconv --with-mcrypt --with-mhash --with-openssl --enable-bcmath --enable-soap --with-libxml-dir --enable-pcntl --enable-shmop --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-sockets --with-curl --with-zlib --enable-zip --with-bz2 --without-sqlite3 --without-pdo-sqlite --with-pear
    make
    make install
    cp ./php.ini-development ${PHP_DIR5}/etc/php.ini
    cp ${PHP_DIR5}/etc/php-fpm.conf.default ${PHP_DIR5}/etc/php-fpm.conf
    cp -R ./sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm5
    chmod +x /etc/init.d/php-fpm5
    cd ..
    /sbin/ldconfig
    echo "php5 install successfully!"
}

function nginx()
{
    cd packages
    is_version
    tar zxf google-perftools-1.6.tar.gz
    cd google-perftools-1.6
    ./configure
    make
    make install
    cd ..
    tar zxf pcre-8.38.tar.gz
    cd pcre-8.38
    ./configure
    make
    make install
    cd ..
    tar zxf nginx-1.11.6.tar.gz
    cd nginx-1.11.6
    ./configure --prefix=${NGINX_DIR} --user=www --group=www --with-http_stub_status_module --with-http_flv_module --with-http_ssl_module
    make && make install
    cd ..
    #rm -rf /usr/local/nginx/conf/nginx.conf
    echo "/usr/local/lib" > /etc/ld.so.conf.d/usr_local_lib.conf
    #$cp nginx.conf /usr/local/nginx/conf
    #cp fcgi.conf /usr/local/nginx/conf
    echo "nginx install successfully!"
    ln -s /lib64/libpcre.so.0.0.1 /lib64/libpcre.so.1
    /usr/local/nginx/sbin/nginx
    echo "nginx start successfully!"
}

function phpizeexe()
{
    cd $1
    ${PHP_DIR}/bin/phpize
    ./configure --with-php-config=${PHP_DIR}/bin/php-config
    make && make install
    cd ..
    rm -rf $1
}

function php_ext()
{
    cd packages
    tar zxvf libevent-2.0.22-stable.tar.gz 
    cd libevent-2.0.22-stable
    ./configure –prefix=/usr/local/libevent
    make && make test && make install
    cd ..
    tar -zxvf memcached-1.4.34.tar.gz
    cd memcached-1.4.34
    ./configure --prefix=${MEMCACHE_DIR}  --with-libevent=/usr/local/libevent/
    make && make install
    /usr/local/bin/memcached -d -m 100 -u root -l 127.0.0.1 -p 11211 -c 256 -P /tmp/memcached.pid
    cd ..
    tar zxvf libmemcached-1.0.9.tar.gz
    cd libmemcached-1.0.9
    ./configure --prefix=/usr/local/libmemcached  --with-memcached
    make && make install
    cd ..
    tar xvzf php-memcached-master.tar.gz
    cd php-memcached-master
    ${PHP_DIR}/bin/phpize
    ./configure --enable-memcached --with-php-config=${PHP_DIR}/bin/php-config --with-libmemcached-dir=/usr/local/libmemcached --disable-memcached-sasl
    make && make install
    cd ..
    yum -y install php-pear autoconf automake libtool make gcc
    tar zxvf protobuf-master.tar.gz
    phpizeexe protobuf-master
    tar -zxvf pecl-memcache-php7.tar.gz
    phpizeexe pecl-memcache-php7
    tar -zxvf m9php-php7.tar.gz
    cd m9php/m9php
    ${PHP_DIR}/bin/phpize
    ./configure --with-php-config=${PHP_DIR}/bin/php-config
    make && make install
    cd ../../
    rm -rf m9php
    tar xvf phpredis-develop.tar.gz
    phpizeexe phpredis-develop
}

# 参考
# http://www.centoscn.com/mysql/2014/1211/4290.html
function mysql()
{
    yum install -y mysql-server mysql mysql-devel
    service mysqld start
    service mysqld restart
    # 开机启动
    chkconfig mysqld on
    read -p "Input Mysql Password...|:" fristPass
    read -p "Repeat Input Mysql Password...|:" secondPass
    if [ $fristPass != $secondPass ]
    then
        echo "password is not empty"
        exit;
    fi
    /usr/bin/mysqladmin -u root password '$fristPass'
    echo "##################"
    echo "mysql install successfully!"
    echo "##################"
}

# 参考
# http://www.cnblogs.com/haoxinyue/p/3620648.html
function redis()
{
    cd packages
    tar xvzf redis-stable.tar.gz
    cd redis-stable
    make
    cp ./src/redis-server /usr/local/bin/
    cp ./src/redis-cli /usr/local/bin/
    mkdir /etc/redis
    mkdir /var/redis
    mkdir /var/redis/log
    mkdir /var/redis/run
    mkdir /var/redis/6379
    cp redis.conf /etc/redis/6379.conf
    sed -i 's/daemonize no/daemonize yes/g' /etc/redis/6379.conf
    sed -i 's/pidfile \/var\/run\/redis_6379.pid/pidfile \/var\/redis\/run\/redis_6379.pid/g' /etc/redis/6379.conf
    sed -i 's/logfile \"\"/logfile\/var\/redis\/log\/redis_6379.log/g' /etc/redis/6379.conf
    sed -i 's/dir .\/dir \/var\/redis\/6379\//g' /etc/redis/6379.conf
    redis-server /etc/redis/6379.conf
    echo "##################"
    echo "mysql install successfully!"
    echo "##################"
}

function check()
{
    #判断nginx是启动是否需要重装
    count=ps -ef | grep $1 | grep -v grep | wc -l
    echo $count
    if [ 0 != $count ]; then
        read -p "Now, {$1} is already enabled, You want to kill the nginx process? Y|y:" killnginx
        case "$killnginx" in
        Y|y)
            #PROCESS = `ps -ef | grep $1 | grep -v grep | grep -v PPID | awk '{print $2}'`
            #for i in $PROCESS
            #do
            #    echo "Kill the $1 process [ $i ]"
            #    kill -9 $i
            #done
            ps -ef | grep $1 | grep -v grep | awk '{print $2}' | xargs kill -9
        ;;
        *)
        echo -n "exit install script -{$1}"
        exit 0
        ;;
        esac
    fi
}

case $1 in
    init)
        init
    ;;
    nginx)
        check nginx
        nginx
    ;;
    php7)
        check php-fpm
        php7
    ;;
    php5)
        check php-fpm
        php5
    ;;
    php-ext)
        php_ext
    ;;
    mysql)
        check mysql
        mysql
    ;;
    redis)
        check redis
        redis
    ;;
    *)
    echo "Usage:`basename $0` {init|mysql|nginx|php7|php5|php-ext}"
    ;;
esac

