module Buildphp
  module Packages
    class Php < Buildphp::Package
      attr_reader :fpm
      attr_accessor :php_modules
      attr_accessor :pecl_modules

      def initialize
        super
        @version = '5.3.0'
        @versions = {
          '5.2.8' => { :md5 => 'e748cace3cfecb66fb6de9a945f98e2a' },
          '5.2.9' => { :md5 => '98b647561dc664adefe296106056cf11' },
          '5.2.10' => { :md5 => '85753ba2909ac9fae5bca516adbda9e9' },
          '5.3.0' => { :md5 => 'f4905eca4497da3f0beb5c96863196b4' },
        }
        # install prefix
        @prefix = "#{@prefix}/php5"
        # enable PHP-FPM? -- http://php-fpm.org/
        @fpm = false
        # php modules to enable
        @php_modules = [
          ### built-in
          # 'bcmath', # For arbitrary precision mathematics PHP offers the Binary Calculator which supports numbers of any size and precision, represented as strings.
          # 'calendar', # The calendar extension presents a series of functions to simplify converting between different calendar formats.
          # 'ctype', # The functions provided by this extension check whether a character or string falls into a certain character class according to the current locale (see also setlocale()).
          # 'dba', # These functions build the foundation for accessing Berkeley DB style databases.
          # 'exif', # With the exif extension you are able to work with image meta data. For example, you may use exif functions to read meta data of pictures taken from digital cameras by working with information stored in the headers of the JPEG and TIFF images.
          # 'fileinfo', # The functions in this module try to guess the content type and encoding of a file by looking for certain magic byte sequences at specific positions within the file. While this is not a bullet proof approach the heuristics used do a very good job.
          # 'filter', # This extension filters data by either validating or sanitizing it. This is especially useful when the data source contains unknown (or foreign) data, like user supplied input. For example, this data may come from an HTML form.
          # 'hash', # Message Digest (hash) engine. Allows direct or incremental processing of arbitrary length messages using a variety of hashing algorithms.
          # 'json', # This extension implements the JavaScript Object Notation (JSON) data-interchange format.
          # 'mbstring', # builtin
          'mysqlnd', # builtin mysql native php driver
          # 'pear', # requires xml explicitly (uncomment the xml line below)
          'pcre',
          # 'sqlite', # builtin
          # 'soap',

          ### require external libs
          # 'bz2', # The bzip2 functions are used to transparently read and write bzip2 (.bz2) compressed files.
          # 'curl', 
          # 'gd', # requires iconv, freetype, jpeg, png, zlib, xpm
          # 'gettext', # requires expat, iconv, ncurses, xml
          # 'iconv',
          # 'mcrypt',
          # 'mhash',
          # 'mysql', # requires zlib, ncurses
          # 'openssl',
          # 'xml', # requires iconv, zlib
          # 'xsl', # requires xml
          # 'zlib',
          # 'zip', # requires zlib

          ### not yet implemented
          # 'imap',
          # 'ldap',
          # 'odbc',
        ]

        @pecl_modules = [
          'apc',
          'eaccelerator',
          'memcache',
        ]

        # which interface to build?
        # supported options:
        #   :fastcgi
        #   :apache2
        @sapi = :fastcgi
      end

      def sapi_flags
        flags = {
          # FastCGI
          # It seems you don't need these for 5.3.0
          :fastcgi => [
            # "--enable-fastcgi",
            # "--enable-discard-path",
            # "--enable-force-cgi-redirect",
          ],
          # Apache2
          :apache2 => [
            # "--with-apxs2=/Applications/MAMP/Library/bin/apxs",
            "--with-apxs2",
          ],
        }
        flags[@sapi]
      end

      def config_file_path
        "#{@prefix}/etc"
      end

      def config_file_scan_dir
        "#{config_file_path}/php.d"
      end

      def php_ini
        "#{config_file_path}/php.ini"
      end

      def custom_ini(name='defaults')
        "#{config_file_scan_dir}/#{name}.ini"
      end

      def modules_ini
        custom_ini('modules')
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

      def package_depends_on
        dependencies = php_modules + ["#{underscored}:get"]
        dependencies << 'php_fpm' if fpm
        dependencies
      end

      def get_build_string
        parts = []
        parts << flags
        parts << "./configure"
        parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil

        # add configuration flags based on which interface we're building
        parts += sapi_flags

        # core PHP options
        parts += [
          "--prefix=#{@prefix}",
          "--with-config-file-path=#{config_file_path}",
          "--with-config-file-scan-dir=#{config_file_scan_dir}",
          "--disable-debug", 
          "--disable-all", # turn off all extensions by default
          "--enable-rpath",
          "--enable-inline-optimization",
          "--enable-libtool-lock",
          "--enable-pdo",
          "--enable-phar",
          "--enable-posix",
          "--enable-session",
          "--enable-short-tags",
          "--enable-tokenizer",
          "--enable-zend-multibyte",
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

      def install_cmd
        %{ make install PHP_PEAR_DOWNLOAD_DIR="#{Buildphp::TMP_DIR}" && make install-cli PHP_PEAR_DOWNLOAD_DIR="#{Buildphp::TMP_DIR}" }
      end

      def is_compiled
        File.file?("#{extract_dir}/sapi/cli/php")
      end

      def is_installed
        File.file?("#{@prefix}/bin/php")
      end

      def extension_dir
        Dir["#{@prefix}/lib/php/extensions/*"][0]
      end

      def rake
        super

        ["#{underscored}:configure", "#{underscored}:force:configure"].map { |t| Rake.application.lookup(t) }.each do |task|
          task.clear_prerequisites.enhance package_depends_on
        end

        ["#{underscored}:install", "#{underscored}:force:install"].map { |t| Rake.application.lookup(t) }.each do |task|
          task.enhance do
            if is_installed and not File.file?(php_ini)
              notice "no php.ini detected. installing ..."
              sh %{
                mkdir -p #{config_file_path} #{config_file_scan_dir}
                cp "#{extract_dir}/php.ini-production" "#{php_ini}"
              }
              notice "enabling compiled modules ..."
              sh %{
  rm -f #{modules_ini}
  echo '; Extension directory (buildphp)' >> #{modules_ini}
  echo 'extension_dir="#{extension_dir}/"' >> #{modules_ini}
  echo '' >> #{modules_ini}
  echo '; Shared modules (buildphp)' >> #{modules_ini}
              }
              FileList["#{extension_dir}/*.so"].map{ |file| File.basename(file) }.each do |file|
                sh "echo 'extension=#{file}' >> #{modules_ini}"
              end

              sh %{
  rm -f #{custom_ini}
  echo 'realpath_cache_size = 1024k' >> #{custom_ini}
  echo 'realpath_cache_ttl = 600' >> #{custom_ini}
  echo '' >> #{custom_ini}
  echo 'memory_limit = -1' >> #{custom_ini}
  echo '' >> #{custom_ini}
  echo 'short_open_tag = On' >> #{custom_ini}
              }

              # create fastcgi wrapper script
              sh %{
  rm -f #{@prefix}/php5.fcgi
  echo '#!/bin/bash' >> #{@prefix}/php5.fcgi
  echo 'PHPRC="#{config_file_path}"' >> #{@prefix}/php5.fcgi
  echo 'export PHPRC' >> #{@prefix}/php5.fcgi
  echo 'PHP_FCGI_CHILDREN=5' >> #{@prefix}/php5.fcgi
  echo 'export PHP_FCGI_CHILDREN' >> #{@prefix}/php5.fcgi
  echo 'PHP_FCGI_MAX_REQUESTS=5000' >> #{@prefix}/php5.fcgi
  echo 'export PHP_FCGI_MAX_REQUESTS' >> #{@prefix}/php5.fcgi
  echo 'exec "#{@prefix}/bin/php-cgi"' >> #{@prefix}/php5.fcgi
              }
            end
          end
        end

        Rake.application[to_sym].clear_prerequisites.enhance(["#{underscored}:compile"])
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
  end 
end