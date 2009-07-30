module Buildphp
  class Php < Package
    
    attr_reader :fpm
    attr_accessor :php_modules
    
    def initialize
      # super
      @version = '5.2.10'
      @versions = {
        '5.2.8' => { :md5 => 'e748cace3cfecb66fb6de9a945f98e2a' },
        '5.2.9' => { :md5 => '98b647561dc664adefe296106056cf11' },
        '5.2.10' => { :md5 => '85753ba2909ac9fae5bca516adbda9e9' },
        '5.3.0' => { :md5 => 'f4905eca4497da3f0beb5c96863196b4' },
      }
      # install paths
      @prefix = "#{INSTALL_TO}/php5"
      # enable PHP-FPM?
      @fpm = false
      # php modules to enable
      @php_modules = [
        # 'bcmath', # For arbitrary precision mathematics PHP offers the Binary Calculator which supports numbers of any size and precision, represented as strings.
        # 'bz2', # The bzip2 functions are used to transparently read and write bzip2 (.bz2) compressed files.
        # 'calendar', # The calendar extension presents a series of functions to simplify converting between different calendar formats.
        # 'ctype', # The functions provided by this extension check whether a character or string falls into a certain character class according to the current locale (see also setlocale()).
        # 'dba', # These functions build the foundation for accessing Berkeley DB style databases.
        # 'exif', # With the exif extension you are able to work with image meta data. For example, you may use exif functions to read meta data of pictures taken from digital cameras by working with information stored in the headers of the JPEG and TIFF images.
        'fileinfo', # The functions in this module try to guess the content type and encoding of a file by looking for certain magic byte sequences at specific positions within the file. While this is not a bullet proof approach the heuristics used do a very good job.
        # 'filter', # This extension filters data by either validating or sanitizing it. This is especially useful when the data source contains unknown (or foreign) data, like user supplied input. For example, this data may come from an HTML form.
        'gettext', # requires expat, iconv, ncurses, xml
        'gd', # requires iconv, freetype, jpeg, png, zlib, xpm
        'hash', # Message Digest (hash) engine. Allows direct or incremental processing of arbitrary length messages using a variety of hashing algorithms.
        # 'iconv',
        'json', # This extension implements the JavaScript Object Notation (JSON) data-interchange format.
        'mbstring', # builtin
        # 'mysql', # requires zlib, ncurses
        'mysqlnd', # builtin mysql native php driver
        'mcrypt',
        'mhash',
        'openssl',
        'pear', # requires xml explicitly (uncomment the xml line below)
        # 'sqlite', # builtin
        'soap',
        'xml', # requires iconv, zlib
        'xsl', # requires xml
        # 'zip',
        'zlib',
      
        # not yet implemented
        # 'ldap',
      ]
      # which interface to build?
      # supported options:
      #   :fastcgi
      #   :apache2
      @sapi = :apache2
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
      dependencies = php_modules + [:get]
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
      %{ make install PHP_PEAR_DOWNLOAD_DIR="#{TMP_DIR}" && make install-cli PHP_PEAR_DOWNLOAD_DIR="#{TMP_DIR}" }
    end
  
    def is_compiled
      File.file?("#{extract_dir}/sapi/cli/php")
    end
  
    def is_installed
      File.file?("#{@prefix}/bin/php")
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
            extension_dir = Dir["#{@prefix}/lib/php/extensions/*"][0]
            sh %{ mkdir -p #{config_file_path} #{config_file_scan_dir} }
            sh %{ cp "#{extract_dir}/php.ini-production" "#{php_ini}" }
            notice "enabling compiled modules ..."
            new_config_file = "#{config_file_scan_dir}/modules.ini"
            sh %{ rm -f #{new_config_file} }
            sh %{ echo '; Extension directory (buildphp)' >> #{new_config_file} }
            sh %{ echo 'extension_dir="#{extension_dir}/"' >> #{new_config_file} }
            sh %{ echo '' >> #{new_config_file} }
            sh %{ echo '; Shared modules (buildphp)' >> #{new_config_file} }
            FileList["#{extension_dir}/*.so"].map{ |file| File.basename(file) }.each do |file|
              sh %{ echo 'extension=#{file}' >> #{new_config_file} }
            end

            # create fastcgi wrapper script
            sh %{
              rm -f #{INSTALL_TO}/php5.fcgi
              echo '#!/bin/bash' >> #{INSTALL_TO}/php5.fcgi
              echo 'PHPRC="#{config_file_path}"' >> #{INSTALL_TO}/php5.fcgi
              echo 'export PHPRC' >> #{INSTALL_TO}/php5.fcgi
              echo 'PHP_FCGI_CHILDREN=5' >> #{INSTALL_TO}/php5.fcgi
              echo 'export PHP_FCGI_CHILDREN' >> #{INSTALL_TO}/php5.fcgi
              echo 'PHP_FCGI_MAX_REQUESTS=5000' >> #{INSTALL_TO}/php5.fcgi
              echo 'export PHP_FCGI_MAX_REQUESTS' >> #{INSTALL_TO}/php5.fcgi
              echo 'exec "#{@prefix}/bin/php-cgi"' >> #{INSTALL_TO}/php5.fcgi
            }
          end
        end
      end
      
      Rake.application[to_sym].clear_prerequisites.enhance(["#{underscored}:compile"])
    end
  end

  # PHP 5.3:
  # 
  # Usage: configure [options] [host]
  # Options: [defaults in brackets after descriptions]
  # Configuration:
  #   --cache-file=FILE       cache test results in FILE
  #   --help                  print this message
  #   --no-create             do not create output files
  #   --quiet, --silent       do not print `checking...' messages
  #   --version               print the version of autoconf that created configure
  # Directory and file names:
  #   --prefix=PREFIX         install architecture-independent files in PREFIX
  #                           [/usr/local]
  #   --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
  #                           [same as prefix]
  #   --bindir=DIR            user executables in DIR [EPREFIX/bin]
  #   --sbindir=DIR           system admin executables in DIR [EPREFIX/sbin]
  #   --libexecdir=DIR        program executables in DIR [EPREFIX/libexec]
  #   --datadir=DIR           read-only architecture-independent data in DIR
  #                           [PREFIX/share]
  #   --sysconfdir=DIR        read-only single-machine data in DIR [PREFIX/etc]
  #   --sharedstatedir=DIR    modifiable architecture-independent data in DIR
  #                           [PREFIX/com]
  #   --localstatedir=DIR     modifiable single-machine data in DIR [PREFIX/var]
  #   --libdir=DIR            object code libraries in DIR [EPREFIX/lib]
  #   --includedir=DIR        C header files in DIR [PREFIX/include]
  #   --oldincludedir=DIR     C header files for non-gcc in DIR [/usr/include]
  #   --infodir=DIR           info documentation in DIR [PREFIX/info]
  #   --mandir=DIR            man documentation in DIR [PREFIX/man]
  #   --srcdir=DIR            find the sources in DIR [configure dir or ..]
  #   --program-prefix=PREFIX prepend PREFIX to installed program names
  #   --program-suffix=SUFFIX append SUFFIX to installed program names
  #   --program-transform-name=PROGRAM
  #                           run sed PROGRAM on installed program names
  # Host type:
  #   --build=BUILD           configure for building on BUILD [BUILD=HOST]
  #   --host=HOST             configure for HOST [guessed]
  #   --target=TARGET         configure for TARGET [TARGET=HOST]
  # Features and packages:
  #   --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
  #   --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
  #   --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
  #   --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
  #   --x-includes=DIR        X include files are in DIR
  #   --x-libraries=DIR       X library files are in DIR
  # --enable and --with options recognized:
  #   --with-libdir=NAME      Look for libraries in .../NAME rather than .../lib
  #   --disable-rpath         Disable passing additional runtime library
  #                           search paths
  #   --enable-re2c-cgoto     Enable -g flag to re2c to use computed goto gcc extension
  # 
  # SAPI modules:
  # 
  #   --with-aolserver=DIR    Specify path to the installed AOLserver
  #   --with-apxs[=FILE]      Build shared Apache 1.x module. FILE is the optional
  #                           pathname to the Apache apxs tool [apxs]
  #   --with-apache[=DIR]     Build Apache 1.x module. DIR is the top-level Apache
  #                           build directory [/usr/local/apache]
  #   --enable-mod-charset      APACHE: Enable transfer tables for mod_charset (Rus Apache)
  #   --with-apxs2filter[=FILE]   
  #                           EXPERIMENTAL: Build shared Apache 2.0 Filter module. FILE is the optional
  #                           pathname to the Apache apxs tool [apxs]
  #   --with-apxs2[=FILE]     Build shared Apache 2.0 Handler module. FILE is the optional
  #                           pathname to the Apache apxs tool [apxs]
  #   --with-apache-hooks[=FILE]      
  #                           EXPERIMENTAL: Build shared Apache 1.x module. FILE is the optional
  #                           pathname to the Apache apxs tool [apxs]
  #   --with-apache-hooks-static[=DIR]
  #                           EXPERIMENTAL: Build Apache 1.x module. DIR is the top-level Apache
  #                           build directory [/usr/local/apache]
  #   --enable-mod-charset      APACHE (hooks): Enable transfer tables for mod_charset (Rus Apache)
  #   --with-caudium[=DIR]    Build PHP as a Pike module for use with Caudium.
  #                           DIR is the Caudium server dir [/usr/local/caudium/server]
  #   --disable-cli           Disable building CLI version of PHP
  #                           (this forces --without-pear)
  #   --with-continuity=DIR   Build PHP as Continuity Server module. 
  #                           DIR is path to the installed Continuity Server root
  #   --enable-embed[=TYPE]   EXPERIMENTAL: Enable building of embedded SAPI library
  #                           TYPE is either 'shared' or 'static'. [TYPE=shared]
  #   --with-isapi[=DIR]      Build PHP as an ISAPI module for use with Zeus
  #   --with-litespeed        Build PHP as litespeed module
  #   --with-milter[=DIR]     Build PHP as Milter application
  #   --with-nsapi=DIR        Build PHP as NSAPI module for Netscape/iPlanet/Sun Webserver
  #   --with-phttpd=DIR       Build PHP as phttpd module
  #   --with-pi3web[=DIR]     Build PHP as Pi3Web module
  #   --with-roxen=DIR        Build PHP as a Pike module. DIR is the base Roxen
  #                           directory, normally /usr/local/roxen/server
  #   --enable-roxen-zts        ROXEN: Build the Roxen module using Zend Thread Safety
  #   --with-thttpd=SRCDIR    Build PHP as thttpd module
  #   --with-tux=MODULEDIR    Build PHP as a TUX module (Linux only)
  #   --with-webjames=SRCDIR  Build PHP as a WebJames module (RISC OS only)
  #   --disable-cgi           Disable building CGI version of PHP
  # 
  # General settings:
  # 
  #   --enable-gcov           Enable GCOV code coverage (requires LTP) - FOR DEVELOPERS ONLY!!
  #   --enable-debug          Compile with debugging symbols
  #   --with-layout=TYPE      Set how installed files will be laid out.  Type can
  #                           be either PHP or GNU [PHP]
  #   --with-config-file-path=PATH
  #                           Set the path in which to look for php.ini [PREFIX/lib]
  #   --with-config-file-scan-dir=PATH
  #                           Set the path where to scan for configuration files
  #   --enable-safe-mode      Enable safe mode by default
  #   --with-exec-dir[=DIR]   Only allow executables in DIR under safe-mode
  #                           [/usr/local/php/bin]
  #   --enable-sigchild       Enable PHP's own SIGCHLD handler
  #   --enable-magic-quotes   Enable magic quotes by default.
  #   --enable-libgcc         Enable explicitly linking against libgcc
  #   --disable-short-tags    Disable the short-form <? start tag by default
  #   --enable-dmalloc        Enable dmalloc
  #   --disable-ipv6          Disable IPv6 support
  #   --enable-fd-setsize     Set size of descriptor sets
  # 
  # Extensions:
  # 
  #   --with-EXTENSION=[shared[,PATH]]
  #   
  #     NOTE: Not all extensions can be build as 'shared'.
  # 
  #     Example: --with-foobar=shared,/usr/local/foobar/
  # 
  #       o Builds the foobar extension as shared extension.
  #       o foobar package install prefix is /usr/local/foobar/
  # 
  # 
  #  --disable-all   Disable all extensions which are enabled by default
  # 
  #   --with-regex=TYPE       regex library type: system, php. [TYPE=php]
  #                           WARNING: Do NOT use unless you know what you are doing!
  #   --disable-libxml        Disable LIBXML support
  #   --with-libxml-dir[=DIR]   LIBXML: libxml2 install prefix
  #   --with-openssl[=DIR]    Include OpenSSL support (requires OpenSSL >= 0.9.6)
  #   --with-kerberos[=DIR]     OPENSSL: Include Kerberos support
  #   --with-pcre-regex=DIR   Include Perl Compatible Regular Expressions support.
  #                           DIR is the PCRE install prefix [BUNDLED]
  #   --without-sqlite3[=DIR] Do not include SQLite3 support. DIR is the prefix to
  #                           SQLite3 installation directory.
  #   --with-zlib[=DIR]       Include ZLIB support (requires zlib >= 1.0.9)
  #   --with-zlib-dir=<DIR>   Define the location of zlib install directory
  #   --enable-bcmath         Enable bc style precision math functions
  #   --with-bz2[=DIR]        Include BZip2 support
  #   --enable-calendar       Enable support for calendar conversion
  #   --disable-ctype         Disable ctype functions
  #   --with-curl[=DIR]       Include cURL support
  #   --with-curlwrappers     Use cURL for url streams
  #   --enable-dba            Build DBA with bundled modules. To build shared DBA
  #                           extension use --enable-dba=shared
  #   --with-qdbm[=DIR]         DBA: QDBM support
  #   --with-gdbm[=DIR]         DBA: GDBM support
  #   --with-ndbm[=DIR]         DBA: NDBM support
  #   --with-db4[=DIR]          DBA: Berkeley DB4 support
  #   --with-db3[=DIR]          DBA: Berkeley DB3 support
  #   --with-db2[=DIR]          DBA: Berkeley DB2 support
  #   --with-db1[=DIR]          DBA: Berkeley DB1 support/emulation
  #   --with-dbm[=DIR]          DBA: DBM support
  #   --without-cdb[=DIR]       DBA: CDB support (bundled)
  #   --disable-inifile         DBA: INI support (bundled)
  #   --disable-flatfile        DBA: FlatFile support (bundled)
  #   --disable-dom           Disable DOM support
  #   --with-libxml-dir[=DIR]   DOM: libxml2 install prefix
  #   --with-enchant[=DIR]     Include enchant support.
  #                           GNU Aspell version 1.1.3 or higher required.
  #   --enable-exif           Enable EXIF (metadata from images) support
  #   --disable-fileinfo      Disable fileinfo support
  #   --disable-filter        Disable input filter support
  #   --with-pcre-dir           FILTER: pcre install prefix
  #   --enable-ftp            Enable FTP support
  #   --with-openssl-dir[=DIR]  FTP: openssl install prefix
  #   --with-gd[=DIR]         Include GD support.  DIR is the GD library base
  #                           install directory [BUNDLED]
  #   --with-jpeg-dir[=DIR]     GD: Set the path to libjpeg install prefix
  #   --with-png-dir[=DIR]      GD: Set the path to libpng install prefix
  #   --with-zlib-dir[=DIR]     GD: Set the path to libz install prefix
  #   --with-xpm-dir[=DIR]      GD: Set the path to libXpm install prefix
  #   --with-freetype-dir[=DIR] GD: Set the path to FreeType 2 install prefix
  #   --with-t1lib[=DIR]        GD: Include T1lib support. T1lib version >= 5.0.0 required
  #   --enable-gd-native-ttf    GD: Enable TrueType string function
  #   --enable-gd-jis-conv      GD: Enable JIS-mapped Japanese font support
  #   --with-gettext[=DIR]    Include GNU gettext support
  #   --with-gmp[=DIR]        Include GNU MP support
  #   --with-mhash[=DIR]      Include mhash support
  #   --disable-hash          Disable hash support
  #   --without-iconv[=DIR]   Exclude iconv support
  #   --with-imap[=DIR]       Include IMAP support. DIR is the c-client install prefix
  #   --with-kerberos[=DIR]     IMAP: Include Kerberos support. DIR is the Kerberos install prefix
  #   --with-imap-ssl[=DIR]     IMAP: Include SSL support. DIR is the OpenSSL install prefix
  #   --with-interbase[=DIR]  Include InterBase support.  DIR is the InterBase base
  #                           install directory [/usr/interbase]
  #   --enable-intl           Enable internationalization support
  #   --with-icu-dir=DIR      Specify where ICU libraries and headers can be found
  #   --disable-json          Disable JavaScript Object Serialization support
  #   --with-ldap[=DIR]       Include LDAP support
  #   --with-ldap-sasl[=DIR]    LDAP: Include Cyrus SASL support
  #   --enable-mbstring       Enable multibyte string support
  #   --disable-mbregex         MBSTRING: Disable multibyte regex support
  #   --disable-mbregex-backtrack
  #                             MBSTRING: Disable multibyte regex backtrack check
  #   --with-libmbfl[=DIR]      MBSTRING: Use external libmbfl.  DIR is the libmbfl base
  #                             install directory [BUNDLED]
  #   --with-onig[=DIR]         MBSTRING: Use external oniguruma. DIR is the oniguruma install prefix.
  #                             If DIR is not set, the bundled oniguruma will be used
  #   --with-mcrypt[=DIR]     Include mcrypt support
  #   --with-mssql[=DIR]      Include MSSQL-DB support.  DIR is the FreeTDS home
  #                           directory [/usr/local/freetds]
  #   --with-mysql[=DIR]      Include MySQL support.  DIR is the MySQL base
  #                           directory.  If mysqlnd is passed as DIR, 
  #                           the MySQL native driver will be used [/usr/local]
  #   --with-mysql-sock[=DIR]   MySQL/MySQLi/PDO_MYSQL: Location of the MySQL unix socket pointer.
  #                             If unspecified, the default locations are searched
  #   --with-zlib-dir[=DIR]     MySQL: Set the path to libz install prefix
  #   --with-mysqli[=FILE]    Include MySQLi support.  FILE is the path
  #                           to mysql_config.  If mysqlnd is passed as FILE,
  #                           the MySQL native driver will be used [mysql_config]
  #   --enable-embedded-mysqli  MYSQLi: Enable embedded support
  #                             Note: Does not work with MySQL native driver!
  #   --with-oci8[=DIR]       Include Oracle (OCI8) support. DIR defaults to $ORACLE_HOME.
  #                           Use --with-oci8=instantclient,/path/to/instant/client/lib 
  #                           to use an Oracle Instant Client installation
  #   --with-adabas[=DIR]     Include Adabas D support [/usr/local]
  #   --with-sapdb[=DIR]      Include SAP DB support [/usr/local]
  #   --with-solid[=DIR]      Include Solid support [/usr/local/solid]
  #   --with-ibm-db2[=DIR]    Include IBM DB2 support [/home/db2inst1/sqllib]
  #   --with-ODBCRouter[=DIR] Include ODBCRouter.com support [/usr]
  #   --with-empress[=DIR]    Include Empress support [$EMPRESSPATH]
  #                           (Empress Version >= 8.60 required)
  #   --with-empress-bcs[=DIR]
  #                           Include Empress Local Access support [$EMPRESSPATH]
  #                           (Empress Version >= 8.60 required)
  #   --with-birdstep[=DIR]   Include Birdstep support [/usr/local/birdstep]
  #   --with-custom-odbc[=DIR]
  #                           Include user defined ODBC support. DIR is ODBC install base
  #                           directory [/usr/local]. Make sure to define CUSTOM_ODBC_LIBS and
  #                           have some odbc.h in your include dirs. f.e. you should define 
  #                           following for Sybase SQL Anywhere 5.5.00 on QNX, prior to
  #                           running this configure script:
  #                               CPPFLAGS="-DODBC_QNX -DSQLANY_BUG"
  #                               LDFLAGS=-lunix
  #                               CUSTOM_ODBC_LIBS="-ldblib -lodbc"
  #   --with-iodbc[=DIR]      Include iODBC support [/usr/local]
  #   --with-esoob[=DIR]      Include Easysoft OOB support [/usr/local/easysoft/oob/client]
  #   --with-unixODBC[=DIR]   Include unixODBC support [/usr/local]
  #   --with-dbmaker[=DIR]    Include DBMaker support
  #   --enable-pcntl          Enable pcntl support (CLI/CGI only)
  #   --disable-pdo           Disable PHP Data Objects support
  #   --with-pdo-dblib[=DIR]    PDO: DBLIB-DB support.  DIR is the FreeTDS home directory
  #   --with-pdo-firebird[=DIR] PDO: Firebird support.  DIR is the Firebird base
  #                             install directory [/opt/firebird]
  #   --with-pdo-mysql[=DIR]    PDO: MySQL support. DIR is the MySQL base directoy
  #                                  If mysqlnd is passed as DIR, the MySQL native
  #                                  native driver will be used [/usr/local]
  #   --with-zlib-dir[=DIR]       PDO_MySQL: Set the path to libz install prefix
  #   --with-pdo-oci[=DIR]      PDO: Oracle OCI support. DIR defaults to $ORACLE_HOME.
  #                             Use --with-pdo-oci=instantclient,prefix,version 
  #                             for an Oracle Instant Client SDK. 
  #                             For Linux with 10.2.0.3 RPMs (for example) use:
  #                             --with-pdo-oci=instantclient,/usr,10.2.0.3
  #   --with-pdo-odbc=flavour,dir
  #                             PDO: Support for 'flavour' ODBC driver.
  #                             include and lib dirs are looked for under 'dir'.
  #                             
  #                             'flavour' can be one of:  ibm-db2, iODBC, unixODBC, generic
  #                             If ',dir' part is omitted, default for the flavour 
  #                             you have selected will used. e.g.:
  #                             
  #                               --with-pdo-odbc=unixODBC
  #                               
  #                             will check for unixODBC under /usr/local. You may attempt 
  #                             to use an otherwise unsupported driver using the "generic" 
  #                             flavour.  The syntax for generic ODBC support is:
  #                             
  #                               --with-pdo-odbc=generic,dir,libname,ldflags,cflags
  # 
  #                             When build as shared the extension filename is always pdo_odbc.so
  #   --with-pdo-pgsql[=DIR]    PDO: PostgreSQL support.  DIR is the PostgreSQL base
  #                             install directory or the path to pg_config
  #   --without-pdo-sqlite[=DIR]
  #                             PDO: sqlite 3 support.  DIR is the sqlite base
  #                             install directory [BUNDLED]
  #   --with-pgsql[=DIR]      Include PostgreSQL support.  DIR is the PostgreSQL
  #                           base install directory or the path to pg_config
  #   --disable-phar          Disable phar support
  #   --disable-posix         Disable POSIX-like functions
  #   --with-pspell[=DIR]     Include PSPELL support.
  #                           GNU Aspell version 0.50.0 or higher required
  #   --with-libedit[=DIR]    Include libedit readline replacement (CLI/CGI only)
  #   --with-readline[=DIR]   Include readline support (CLI/CGI only)
  #   --with-recode[=DIR]     Include recode support
  #   --disable-session       Disable session support
  #   --with-mm[=DIR]           SESSION: Include mm support for session storage
  #   --enable-shmop          Enable shmop support
  #   --disable-simplexml     Disable SimpleXML support
  #   --with-libxml-dir=DIR     SimpleXML: libxml2 install prefix
  #   --with-snmp[=DIR]       Include SNMP support
  #   --with-openssl-dir[=DIR]  SNMP: openssl install prefix
  #   --enable-ucd-snmp-hack    SNMP: Enable UCD SNMP hack
  #   --enable-soap           Enable SOAP support
  #   --with-libxml-dir=DIR     SOAP: libxml2 install prefix
  #   --enable-sockets        Enable sockets support
  #   --without-sqlite=DIR    Do not include sqlite support.  DIR is the sqlite base
  #                           install directory [BUNDLED]
  #   --enable-sqlite-utf8      SQLite: Enable UTF-8 support for SQLite
  #   --with-sybase-ct[=DIR]  Include Sybase-CT support.  DIR is the Sybase home
  #                           directory [/home/sybase]
  #   --enable-sysvmsg        Enable sysvmsg support
  #   --enable-sysvsem        Enable System V semaphore support
  #   --enable-sysvshm        Enable the System V shared memory support
  #   --with-tidy[=DIR]       Include TIDY support
  #   --disable-tokenizer     Disable tokenizer support
  #   --enable-wddx           Enable WDDX support
  #   --with-libxml-dir=DIR     WDDX: libxml2 install prefix
  #   --with-libexpat-dir=DIR   WDDX: libexpat dir for XMLRPC-EPI (deprecated)
  #   --disable-xml           Disable XML support
  #   --with-libxml-dir=DIR     XML: libxml2 install prefix
  #   --with-libexpat-dir=DIR   XML: libexpat install prefix (deprecated)
  #   --disable-xmlreader     Disable XMLReader support
  #   --with-libxml-dir=DIR     XMLReader: libxml2 install prefix
  #   --with-xmlrpc[=DIR]     Include XMLRPC-EPI support
  #   --with-libxml-dir=DIR     XMLRPC-EPI: libxml2 install prefix
  #   --with-libexpat-dir=DIR   XMLRPC-EPI: libexpat dir for XMLRPC-EPI (deprecated)
  #   --with-iconv-dir=DIR      XMLRPC-EPI: iconv dir for XMLRPC-EPI
  #   --disable-xmlwriter     Disable XMLWriter support
  #   --with-libxml-dir=DIR     XMLWriter: libxml2 install prefix
  #   --with-xsl[=DIR]        Include XSL support.  DIR is the libxslt base
  #                           install directory (libxslt >= 1.1.0 required)
  #   --enable-zip            Include Zip read/write support
  #   --with-zlib-dir[=DIR]     ZIP: Set the path to libz install prefix
  #   --with-pcre-dir           ZIP: pcre install prefix
  #   --enable-mysqlnd-threading
  #                             EXPERIMENTAL: Enable mysqlnd threaded fetch.
  #                             Note: This forces ZTS on!
  # 
  # PEAR:
  # 
  #   --with-pear=DIR         Install PEAR in DIR [PREFIX/lib/php]
  #   --without-pear          Do not install PEAR
  # 
  # Zend:
  # 
  #   --with-zend-vm=TYPE     Set virtual machine dispatch method. Type is
  #                           one of CALL, SWITCH or GOTO [TYPE=CALL]
  #   --enable-maintainer-zts Enable thread safety - for code maintainers only!!
  #   --disable-inline-optimization 
  #                           If building zend_execute.lo fails, try this switch
  #   --enable-zend-multibyte Compile with zend multibyte support
  # 
  # TSRM:
  # 
  #   --with-tsrm-pth[=pth-config]
  #                           Use GNU Pth
  #   --with-tsrm-st          Use SGI's State Threads
  #   --with-tsrm-pthreads    Use POSIX threads (default)
  # 
  # Libtool:
  # 
  #   --enable-shared[=PKGS]  build shared libraries [default=yes]
  #   --enable-static[=PKGS]  build static libraries [default=yes]
  #   --enable-fast-install[=PKGS]  optimize for fast installation [default=yes]
  #   --with-gnu-ld           assume the C compiler uses GNU ld [default=no]
  #   --disable-libtool-lock  avoid locking (might break parallel builds)
  #   --with-pic              try to use only PIC/non-PIC objects [default=use both]
  #   --with-tags[=TAGS]      include additional configurations [automatic]
  # 
  #   --with-gnu-ld           assume the C compiler uses GNU ld [default=no]




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