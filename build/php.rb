class Php < BuildTaskAbstract
  @filename = 'php-5.2.8.tar.gz'
  @dir = 'php-5.2.8'
  @config = {
    :package => {
      :depends_on => [
        'bz2',
        # 'mysql',
      ],
      :dir => dir,
      :name => filename,
      :location => "http://www.php.net/get/#{filename}/from/this/mirror",
      :md5 => 'e748cace3cfecb66fb6de9a945f98e2a',
    },
    :extract => {
      :dir => File.join(EXTRACT_TO, dir),
      :cmd => "tar xfz #{filename}",
    },
  }
  class << self
    def get_build_string
      parts = []
      parts << flags
      parts << "./configure"

      # Apache2
      # parts.push "--with-apxs2=#{INSTALL_TO}/sbin/apxs"
      # FastCGI
      parts += [
        "--enable-fastcgi",
        "--enable-discard-path",
        "--enable-force-cgi-redirect",
      ]

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
      
      if RUBY_PLATFORM == 'x86_64-linux'
        parts << "--with-pic"
      end
      
      # Built-in Extensions
      parts += [
        "--enable-bcmath",
        "--enable-calendar",
      ]
      
      # Extensions that depend on external libraries
      # Get config flags from dependencies
      config[:package][:depends_on].map { |ext| Inflect.camelize(ext) }.each do |ext|
        parts += Kernel.const_get(ext).config[:php_config_flags] || []
      end
      
      parts.join(' ')
    end
    def is_installed
      File.exists?(File.join(INSTALL_TO, 'bin', 'php'))
    end
  end
end

namespace :php do
  task :get do
    Php.get()
  end
  
  task :configure => (Php.config[:package][:depends_on].map { |ext| ext + ':install' } + [
    :get, 
    # PHP-FPM: Baked-in FastCGI process management for PHP
    # Homepage: http://php-fpm.anight.org/
    # Explanation: http://interfacelab.com/nginx-php-fpm-apc-awesome/
    'php_fpm:install',
  ]) do
    Php.configure()
  end

  task :compile => :configure do
    Php.compile()
  end
  
  task :install => :compile do
    Php.install("make install PHP_PEAR_DOWNLOAD_DIR=\"#{TMP_DIR}\" && make install-cli PHP_PEAR_DOWNLOAD_DIR=\"#{TMP_DIR}\"")
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
