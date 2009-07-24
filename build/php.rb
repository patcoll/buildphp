class Php < BuildTaskAbstract
  VERSION = '5.3.0'
  
  def versions
    {
      '5.2.8' => { :md5 => 'e748cace3cfecb66fb6de9a945f98e2a' },
      '5.3.0' => { :md5 => 'f4905eca4497da3f0beb5c96863196b4' },
    }
  end
  
  # enable PHP-FPM?
  def fpm
    false
  end
  
  def package_name
    'php-%s.tar.gz' % @version
  end
  
  def package_dir
    'php-%s' % @version
  end
  
  def package_location
    'http://www.php.net/get/%s/from/this/mirror' % package_name
  end
  
  def php_modules
    [
      'xml',
      'iconv',
      'bz2',
      'zlib',
      'mysql',
    ]
  end
  
  def package_depends_on
    dependencies = php_modules + [:get]
    dependencies << 'php_fpm' if fpm
    dependencies
  end
  
  def get_build_string
    parts = []
    parts << flags
    parts << "./configure"

    parts << "--with-pic" if RUBY_PLATFORM == 'x86_64-linux'

    # Apache2
    # parts.push "--with-apxs2=#{INSTALL_TO}/sbin/apxs"
    # FastCGI
    # It also seems you don't need these for 5.3+
    # parts += [
    #   "--enable-fastcgi",
    #   "--enable-discard-path",
    #   "--enable-force-cgi-redirect",
    # ]

    # PHP stufz
    parts += [
      "--prefix=#{INSTALL_TO}/php5",
      "--with-config-file-path=#{INSTALL_TO}/php5/etc",
      "--with-config-file-scan-dir=#{INSTALL_TO}/php5/etc/php.d",
      "--with-pear=#{INSTALL_TO}/php5/share/pear",
      "--disable-debug",
      "--disable-rpath",
      "--enable-inline-optimization",
    ]
    
    # Built-in Extensions
    parts += [
      "--enable-bcmath",
      "--enable-calendar",
    ]
    
    # PHP-FPM
    parts += FACTORY.get('PhpFpm').php_config_flags if fpm
    
    # Extensions that depend on external libraries
    # Get config flags from dependencies
    php_modules.map { |ext| Inflect.camelize(ext) }.each do |ext|
      parts += FACTORY.get(ext).php_config_flags || []
    end
    
    parts.join(' ')
  end
  
  def is_installed
    File.exists?(File.join(INSTALL_TO, 'php5', 'bin', 'php'))
  end
end





# Valid for PHP 5.3.0beta1:
# ./configure --prefix=/usr/local --with-config-file-path=/usr/local/etc --with-config-file-scan-dir=/usr/local/etc/php.d --disable-debug --enable-pic --disable-rpath --enable-inline-optimization --with-bz2=shared --with-db4=shared,/usr --with-curl=shared --with-freetype-dir=/opt/local --with-png-dir=/usr --with-gd=shared --enable-gd-native-ttf --without-gdbm --with-gettext=shared --with-ncurses=shared --with-gmp=shared --with-iconv=shared --with-jpeg-dir=/opt/local --with-openssl=shared --with-png-dir=/opt/local --with-pspell=shared,/opt/local --with-xml=shared --with-expat-dir=/usr --with-dom=shared,/usr --with-dom-xslt=shared,/usr --with-dom-exslt=shared,/usr --with-xmlrpc=shared --with-pcre-regex=/opt/local --with-zlib=shared --enable-bcmath --enable-exif --enable-ftp --enable-sockets --enable-sysvsem --enable-sysvshm --enable-track-vars --enable-trans-sid --enable-yp --enable-wddx --with-pear=/opt/local/pear --with-imap=shared,/opt/local/imap-2006h --with-imap-ssl=shared --with-kerberos --with-ldap=shared --with-mysql=shared,/opt/local/mysql --with-pdo-mysql=shared,/opt/local/mysql --with-pgsql=shared,/opt/local --with-pdo-pgsql=shared,/opt/local --enable-ucd-snmp-hack --with-unixODBC=shared,/usr --enable-memory-limit --enable-shmop --enable-calendar --enable-dbx --enable-dio --enable-mbstring --enable-mbstr-enc-trans --enable-mbregex --with-mime-magic=/usr/share/file/magic.mime --with-xsl=shared,/usr/local --enable-fastcgi --enable-discard-path --enable-force-cgi-redirect



# 
# --with-bz2=shared
# --with-db4=shared,/usr
# --with-curl=shared
# --with-freetype-dir=/opt/local
# --with-png-dir=/usr
# --with-gd=shared,/opt/local
# --enable-gd-native-ttf
# --without-gdbm
# --with-gettext=shared
# --with-ncurses=shared
# --with-gmp=shared
# --with-iconv=shared
# --with-jpeg-dir=/opt/local
# --with-openssl=shared
# --with-png-dir=/opt/local
# --with-pspell=shared,/opt/local
# --with-xml=shared
# --with-expat-dir=/usr
# --with-dom=shared,/usr
# --with-dom-xslt=shared,/usr
# --with-dom-exslt=shared,/usr
# --with-xmlrpc=shared
# --with-pcre-regex=/opt/local
# --with-zlib=shared
# --enable-bcmath
# --enable-exif
# --enable-ftp
# --enable-sockets
# --enable-sysvsem
# --enable-sysvshm
# --enable-track-vars
# --enable-trans-sid
# --enable-yp
# --enable-wddx
# --with-pear=/opt/local/pear
# --with-imap=shared,/opt/local/imap-2006h
# --with-imap-ssl=shared
# --with-kerberos
# --with-ldap=shared
# --with-mysql=shared,/opt/local/mysql
# --with-pdo-mysql=shared,/opt/local/mysql
# --with-pgsql=shared,/opt/local
# --with-pdo-pgsql=shared,/opt/local
# --enable-ucd-snmp-hack
# --with-unixODBC=shared,/usr
# --enable-memory-limit
# --enable-shmop
# --enable-calendar
# --enable-dbx
# --enable-dio
# --enable-mbstring
# --enable-mbstr-enc-trans
# --enable-mbregex
# --with-xsl=shared,/usr/local
# 
