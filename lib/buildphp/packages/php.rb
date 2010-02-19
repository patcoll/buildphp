:php.version '5.2.10', :md5 => '85753ba2909ac9fae5bca516adbda9e9'
:php.version '5.3.0',  :md5 => 'f4905eca4497da3f0beb5c96863196b4'
:php.version '5.3.1',  :md5 => '41fbb368d86acb13fc3519657d277681'

package :php => %w(bz2 curl gd gettext iconv mcrypt mhash mssql odbc openssl pear pcre soap xml xsl zlib zip) do |php|
  php.version = '5.3.1'
  php.file = "php-#{php.version}.tar.gz"
  php.location = "http://www.php.net/get/#{php.file}/from/this/mirror"
  php.prefix = "#{php.prefix}/php5"

  php.add_attr :fpm, :sapi, :build_apache
  php.fpm = false
  php.sapi = :apache2
  php.build_apache = true
  php.depends_on.unshift 'apache' if php.build_apache
  
  # mysql driver
  php.depends_on << 'mysqlnd' # or 'mysql'
  php.depends_on.sort!
  php.depends_on << 'php:get'
  # p php.depends_on
  
  php.create_method :sapi_flags do
    flags = []
    if php.sapi == :apache2
      if Buildphp::MAMP_MODE
        flags << "--with-apxs2=/Applications/MAMP/Library/bin/apxs"
      elsif php.build_apache
        flags << "--with-apxs2=#{FACTORY.apache.prefix}/bin/apxs"
      else
        flags << "--with-apxs2"
      end
    elsif php.sapi == :fastcgi
      flags << "--enable-fastcgi"
      flags << "--enable-discard-path"
      flags << "--enable-force-cgi-redirect"
    end
    flags
  end
  # p php.sapi_flags
  
  php.add_attr :config_file_path, :config_file_scan_dir, :php_ini
  php.config_file_path = "#{php.prefix}/etc"
  php.config_file_scan_dir = "#{php.config_file_path}/php.d"
  php.php_ini = "#{php.config_file_path}/php.ini"
  
  php.create_method :custom_ini do |name|
    name ||= 'defaults'
    "#{php.config_file_scan_dir}/#{name}.ini"
  end
  # p php.custom_ini
  # p php.custom_ini 'asd'
  
  php.create_method :modules_ini do
    php.custom_ini 'modules'
  end
  # p php.modules_ini
  
  php.configure do |parts|
    parts << "--with-pic" if system_is_64_bit?
    parts << "--with-gnu-ld"

    # add configuration flags based on which interface we're building
    parts << php.sapi_flags

    # core PHP options
    parts << %W(
      --prefix="#{php.prefix}"
      --with-config-file-path="#{php.config_file_path}"
      --with-config-file-scan-dir="#{php.config_file_scan_dir}"
      --disable-debug 
      --disable-all
      --enable-rpath
      --enable-inline-optimization
      --enable-libtool-lock
      --enable-pdo
      --enable-phar
      --enable-posix
      --enable-session
      --enable-spl
      --enable-short-tags
      --enable-tokenizer
      --enable-zend-multibyte
    )

    ### built-ins.
    ### these packages have code which is packaged with the PHP core distribution.
    # bcmath
    # For arbitrary precision mathematics PHP offers the Binary Calculator which supports numbers of any size and precision, represented as strings.
    # http://us2.php.net/manual/en/ref.bc.php
    parts << "--enable-bcmath"
    # calendar
    # The calendar extension presents a series of functions to simplify converting between different calendar formats.
    # http://us2.php.net/manual/en/intro.calendar.php
    parts << "--enable-calendar"
    # ctype
    # The functions provided by this extension check whether a character or string falls into a certain character class according to the current locale (see also setlocale()).
    # http://us2.php.net/manual/en/intro.ctype.php
    parts << "--enable-ctype"
    # dba
    # These functions build the foundation for accessing Berkeley DB style databases.
    # http://us2.php.net/manual/en/intro.dba.php
    parts << "--enable-dba"
    parts << "--with-cdb"
    parts << "--enable-inifile"
    parts << "--enable-flatfile"
    # exif
    # With the exif extension you are able to work with image meta data. For example, you may use exif functions to read meta data of pictures taken from digital cameras by working with information stored in the headers of the JPEG and TIFF images.
    # http://us2.php.net/manual/en/intro.exif.php
    parts << "--enable-exif"
    # fileinfo
    # The functions in this module try to guess the content type and encoding of a file by looking for certain magic byte sequences at specific positions within the file. While this is not a bullet proof approach the heuristics used do a very good job.
    # http://us2.php.net/manual/en/intro.fileinfo.php
    parts << "--enable-fileinfo"
    # filter
    # This extension filters data by either validating or sanitizing it. This is especially useful when the data source contains unknown (or foreign) data, like user supplied input. For example, this data may come from an HTML form.
    # http://us2.php.net/manual/en/intro.filter.php
    parts << "--enable-filter"
    # hash
    # Message Digest (hash) engine. Allows direct or incremental processing of arbitrary length messages using a variety of hashing algorithms.
    parts << "--enable-hash"
    # json
    # This extension implements the JavaScript Object Notation (JSON) data-interchange format.
    parts << "--enable-json"
    # mbstring
    # mbstring provides multibyte specific string functions that help you deal with multibyte encodings in PHP.
    parts << "--enable-mbstring"
    parts << "--enable-mbregex"
    parts << "--enable-mbregex-backtrack"
    parts << "--with-libmbfl"
    # builtin mysql native php driver
    # mysqlnd
    parts << "--with-mysql=shared,mysqlnd"
    parts << "--with-pdo-mysql=shared,mysqlnd"
    parts << "--with-mysqli=shared,mysqlnd"
    # This is an extension for the SQLite Embeddable SQL Database Engine.
    # sqlite
    parts << "--with-sqlite3"
    parts << "--with-pdo-sqlite"
    parts << "--enable-sqlite-utf8"
  end
  # puts php.configure_cmd
  # puts php.configure_cmd './config'
  # p php.configure_cmd2
  
  # php.configure :apache do |c|
  #   c << '--apache'
  #   c << '--configure'
  #   c << '--flags'
  # end
  
  # p php.configure :apache
  # p php.md5

  # php.configure do |c|
  #   p c
  # end
  # def custom_ini(name='defaults')
  #   "#{config_file_scan_dir}/#{name}.ini"
  # end
  # 
  # def modules_ini
  #   custom_ini('modules')
  # end
  
  php.install_cmd = %{make install PHP_PEAR_DOWNLOAD_DIR="#{Buildphp::TMP_DIR}" && make install-cli PHP_PEAR_DOWNLOAD_DIR="#{Buildphp::TMP_DIR}"}
  
  php.create_method :is_installed do
    File.file?("#{php.prefix}/bin/php")
  end

  # p php.is_installed
  
  php.create_method :is_compiled do
    File.file?("#{php.extract_dir}/sapi/cli/php")
  end
  
  php.create_method :is_installed do
    File.file?("#{php.prefix}/bin/php")
  end
  
  php.create_method :extension_dir do
    Dir["#{php.prefix}/lib/php/extensions/*"][0]
  end
  
  php.rake do
    ["#{php}:configure", "#{php}:force:configure"].map { |t| Rake.application.lookup(t) }.each do |task|
      task.clear_prerequisites.enhance php.depends_on
    end
    
    Rake.application.in_namespace(php.to_sym) do
      task :httpdconf do
        if php.sapi == :apache2 and Buildphp::MAMP_MODE then
          sh %[ln -nfs /Applications/MAMP/conf/apache/httpd.conf /Applications/MAMP/Library/conf/httpd.conf]
        end
      end
    end

    ["#{php}:install", "#{php}:force:install"].map { |t| Rake.application.lookup(t) }.each do |task|
      task.enhance [:httpdconf] do
        Rake.application["#{php}:ini"].invoke
        Rake.application["#{php}:fastcgi_script"].invoke
      end
    end
    
    Rake.application.in_namespace(php.to_sym) do
      # 
      task :ini do
        if php.is_installed and not File.file?(php.php_ini)
          notice "no php.ini detected. installing ..."
          sh %{
            mkdir -p #{php.config_file_path} #{php.config_file_scan_dir}
            cp "#{php.extract_dir}/php.ini-production" "#{php.php_ini}" || cp "#{php.extract_dir}/php.ini-recommended" "#{php.php_ini}"
          }
          notice "enabling compiled modules ..."
          sh %{
            rm -f #{php.modules_ini}
            echo '; Extension directory (buildphp)' >> #{php.modules_ini}
            echo 'extension_dir="#{php.extension_dir}/"' >> #{php.modules_ini}
            echo '' >> #{php.modules_ini}
            echo '; Shared modules (buildphp)' >> #{php.modules_ini}
          }
          FileList["#{php.extension_dir}/*.so"].map{ |file| File.basename(file) }.each do |file|
            sh "echo 'extension=#{file}' >> #{php.modules_ini}"
          end

          sh %{
            rm -f #{php.custom_ini}
            echo 'realpath_cache_size = 1024k' >> #{php.custom_ini}
            echo 'realpath_cache_ttl = 600' >> #{php.custom_ini}
            echo '' >> #{php.custom_ini}
            echo 'memory_limit = -1' >> #{php.custom_ini}
            echo '' >> #{php.custom_ini}
            echo 'short_open_tag = On' >> #{php.custom_ini}
          }

        end
      end

      task :fastcgi_script do
          # create fastcgi wrapper script
          sh %{
            rm -f #{php.prefix}/php5.fcgi
            echo '#!/bin/bash' >> #{php.prefix}/php5.fcgi
            echo 'PHPRC="#{config_file_path}"' >> #{php.prefix}/php5.fcgi
            echo 'export PHPRC' >> #{php.prefix}/php5.fcgi
            echo 'PHP_FCGI_CHILDREN=5' >> #{php.prefix}/php5.fcgi
            echo 'export PHP_FCGI_CHILDREN' >> #{php.prefix}/php5.fcgi
            echo 'PHP_FCGI_MAX_REQUESTS=5000' >> #{php.prefix}/php5.fcgi
            echo 'export PHP_FCGI_MAX_REQUESTS' >> #{php.prefix}/php5.fcgi
            echo 'exec "#{php.prefix}/bin/php-cgi"' >> #{php.prefix}/php5.fcgi
          } if php.sapi == :fastcgi
      end
    end
    Rake.application[php.to_sym].clear_prerequisites.enhance(["#{php}:compile"])
  end
  
  # p php.configure_cmd
end



# module Buildphp
#   module Packages
#     class Php < Buildphp::Package
#       # attr_reader :fpm
#       # attr_reader :sapi
#       # attr_accessor :php_modules
# 
#       # def initialize
#       #   super
#       #   @version = '5.3.1'
#       #   @versions = {
#       #     '5.2.6' => { :md5 => '1720f95f26c506338f0dba3a51906bbd' },
#       #     '5.2.8' => { :md5 => 'e748cace3cfecb66fb6de9a945f98e2a' },
#       #     '5.2.9' => { :md5 => '98b647561dc664adefe296106056cf11' },
#       #     '5.2.10' => { :md5 => '85753ba2909ac9fae5bca516adbda9e9' },
#       #     '5.3.0' => { :md5 => 'f4905eca4497da3f0beb5c96863196b4' },
#       #     '5.3.1' => { :md5 => '41fbb368d86acb13fc3519657d277681' },
#       #   }
#       #   # install prefix
#       #   @prefix = "#{@prefix}/php5"
#       #   # enable PHP-FPM? -- http://php-fpm.org/
#       #   # TODO: update build script for newest PHP-FPM version, which is a separate compile now, not a patch.
#       #   @fpm = false
#       #   ### php modules to enable.
#       #   ### all optional.
#       #   @php_modules = [
#       #     # ### these packages require external libs.
#       #     # ### only put packages here if PHP has a direct dependency on the package.
#       #     # ### a good example of this is "png" which only the "gd" package has a direct dependency on.
#       #     'bz2', # The bzip2 functions are used to transparently read and write bzip2 (.bz2) compressed files.
#       #     'curl', # PHP supports libcurl, a library created by Daniel Stenberg, that allows you to connect and communicate to many different types of servers with many different types of protocols.
#       #     'gd', # PHP can output image streams directly to a browser. You will need to compile PHP with the GD library of image functions for this to work. requires iconv, freetype, jpeg, png, zlib, xpm
#       #     'gettext', # The gettext functions implement an NLS (Native Language Support) API which can be used to internationalize your PHP applications. requires expat, iconv, ncurses, xml
#       #     'iconv', # This module contains an interface to iconv character set conversion facility.
#       #     'mcrypt', # This is an interface to the mcrypt library, which supports a wide variety of block algorithms
#       #     'mhash', # This is an interface to the mhash library. mhash supports a wide variety of hash algorithms such as MD5, SHA1, GOST, and many others.
#       #     # 'mysql', # not needed if 'mysqlnd' is included from above. requires zlib, ncurses.
#       #     'mssql', # These functions allow you to access MS SQL Server database.
#       #     'odbc',
#       #     'openssl',
#       #     'pear', # requires xml explicitly (uncomment the xml line below)
#       #     'pcre', # Perl-compatible regular expressions. The syntax for patterns used in these functions closely resembles Perl.
#       #     'soap', # requires xml. The SOAP extension can be used to write SOAP Servers and Clients. It supports subsets of SOAP 1.1, SOAP 1.2 and WSDL 1.1 specifications.
#       #     'xml', # requires iconv, zlib
#       #     'xsl', # requires xml
#       #     'zlib',
#       #     'zip', # requires zlib
#       # 
#       #     ### not yet implemented
#       #     # 'imap',
#       #     # 'ldap',
#       #   ]
#       # 
#       #   # which interface to build?
#       #   # supported options:
#       #   #   :apache2
#       #   #   :fastcgi
#       #   @sapi = :apache2
#       # 
#       #   # build apache as a dependency?
#       #   @build_apache = true
#       # end
#       
#       # def pecl_modules
#       #   FACTORY.packages.find_all { |package| package.is_pecl }
#       # end
# 
#       # def sapi_flags
#       #   flags = []
#       #   if @sapi == :apache2
#       #     if Buildphp::MAMP_MODE
#       #       flags << "--with-apxs2=/Applications/MAMP/Library/bin/apxs"
#       #     elsif @build_apache
#       #       flags << "--with-apxs2=#{FACTORY['Apache'].prefix}/bin/apxs"
#       #     else
#       #       flags << "--with-apxs2"
#       #     end
#       #   elsif @sapi == :fastcgi
#       #     flags << "--enable-fastcgi"
#       #     flags << "--enable-discard-path"
#       #     flags << "--enable-force-cgi-redirect"
#       #   end
#       #   return flags
#       # end
# 
#       # def config_file_path
#       #   "#{@prefix}/etc"
#       # end
#       # 
#       # def config_file_scan_dir
#       #   "#{config_file_path}/php.d"
#       # end
#       # 
#       # def php_ini
#       #   "#{config_file_path}/php.ini"
#       # end
#       # 
#       # def custom_ini(name='defaults')
#       #   "#{config_file_scan_dir}/#{name}.ini"
#       # end
#       # 
#       # def modules_ini
#       #   custom_ini('modules')
#       # end
# 
#       # def package_name
#       #   file
#       # end
#       # 
#       # def package_dir
#       #   package_dir
#       # end
# 
#       # def package_location
#       #   'http://www.php.net/get/%s/from/this/mirror' % package_name
#       # end
# 
#       # def package_depends_on
#       #   dependencies = [:m4, :autoconf, :automake, :libtool]
#       #   # dependencies = []
#       #   dependencies << :apache if @build_apache
#       #   dependencies += php_modules
#       #   # dependencies << :binutils
#       #   dependencies << "#{self}:get"
#       #   dependencies << 'php_fpm' if fpm
#       #   dependencies
#       # end
# 
#       # def get_build_string
#       #   parts = []
#       #   parts << configure_prefix
#       #   parts << "./configure"
#       #   parts << "--with-pic" if system_is_64_bit?
#       #   parts << "--with-gnu-ld"
#       # 
#       #   # add configuration flags based on which interface we're building
#       #   parts += sapi_flags
#       # 
#       #   # core PHP options
#       #   parts += [
#       #     "--prefix=#{@prefix}",
#       #     "--with-config-file-path=#{config_file_path}",
#       #     "--with-config-file-scan-dir=#{config_file_scan_dir}",
#       #     "--disable-debug", 
#       #     "--disable-all", # turn off all extensions by default
#       #     "--enable-rpath",
#       #     "--enable-inline-optimization",
#       #     "--enable-libtool-lock",
#       #     "--enable-pdo",
#       #     "--enable-phar",
#       #     "--enable-posix",
#       #     "--enable-session",
#       #     "--enable-spl",
#       #     "--enable-short-tags",
#       #     "--enable-tokenizer",
#       #     "--enable-zend-multibyte",
#       #   ]
#       # 
#       #   ### built-ins.
#       #   ### these packages have code which is packaged with the PHP core distribution.
#       #   # bcmath
#       #   # For arbitrary precision mathematics PHP offers the Binary Calculator which supports numbers of any size and precision, represented as strings.
#       #   # http://us2.php.net/manual/en/ref.bc.php
#       #   parts << "--enable-bcmath"
#       #   # calendar
#       #   # The calendar extension presents a series of functions to simplify converting between different calendar formats.
#       #   # http://us2.php.net/manual/en/intro.calendar.php
#       #   parts << "--enable-calendar"
#       #   # ctype
#       #   # The functions provided by this extension check whether a character or string falls into a certain character class according to the current locale (see also setlocale()).
#       #   # http://us2.php.net/manual/en/intro.ctype.php
#       #   parts << "--enable-ctype"
#       #   # dba
#       #   # These functions build the foundation for accessing Berkeley DB style databases.
#       #   # http://us2.php.net/manual/en/intro.dba.php
#       #   parts << "--enable-dba"
#       #   parts << "--with-cdb"
#       #   parts << "--enable-inifile"
#       #   parts << "--enable-flatfile"
#       #   # exif
#       #   # With the exif extension you are able to work with image meta data. For example, you may use exif functions to read meta data of pictures taken from digital cameras by working with information stored in the headers of the JPEG and TIFF images.
#       #   # http://us2.php.net/manual/en/intro.exif.php
#       #   parts << "--enable-exif"
#       #   # fileinfo
#       #   # The functions in this module try to guess the content type and encoding of a file by looking for certain magic byte sequences at specific positions within the file. While this is not a bullet proof approach the heuristics used do a very good job.
#       #   # http://us2.php.net/manual/en/intro.fileinfo.php
#       #   parts << "--enable-fileinfo"
#       #   # filter
#       #   # This extension filters data by either validating or sanitizing it. This is especially useful when the data source contains unknown (or foreign) data, like user supplied input. For example, this data may come from an HTML form.
#       #   # http://us2.php.net/manual/en/intro.filter.php
#       #   parts << "--enable-filter"
#       #   # hash
#       #   # Message Digest (hash) engine. Allows direct or incremental processing of arbitrary length messages using a variety of hashing algorithms.
#       #   parts << "--enable-hash"
#       #   # json
#       #   # This extension implements the JavaScript Object Notation (JSON) data-interchange format.
#       #   parts << "--enable-json"
#       #   # mbstring
#       #   # mbstring provides multibyte specific string functions that help you deal with multibyte encodings in PHP.
#       #   parts << "--enable-mbstring"
#       #   parts << "--enable-mbregex"
#       #   parts << "--enable-mbregex-backtrack"
#       #   parts << "--with-libmbfl"
#       #   # builtin mysql native php driver
#       #   # mysqlnd
#       #   parts << "--with-mysql=shared,mysqlnd"
#       #   parts << "--with-pdo-mysql=shared,mysqlnd"
#       #   parts << "--with-mysqli=shared,mysqlnd"
#       #   # This is an extension for the SQLite Embeddable SQL Database Engine.
#       #   # sqlite
#       #   parts << "--with-sqlite3"
#       #   parts << "--with-pdo-sqlite"
#       #   parts << "--enable-sqlite-utf8"
#       #   
#       #   
#       # 
#       #   # PHP-FPM
#       #   parts += FACTORY['php_fpm'].php_config_flags if fpm
#       # 
#       #   # Extensions that depend on external libraries
#       #   # Get config flags from dependencies
#       #   php_modules.map { |ext| Inflect.camelize(ext) }.each do |ext|
#       #     parts += FACTORY[ext].php_config_flags || []
#       #   end
#       # 
#       #   parts.join(' ')
#       # end
# 
#       # def install_cmd
#       #   %[make install PHP_PEAR_DOWNLOAD_DIR="#{Buildphp::TMP_DIR}" && make install-cli PHP_PEAR_DOWNLOAD_DIR="#{Buildphp::TMP_DIR}"]
#       # end
# 
#       # def is_compiled
#       #   File.file?("#{extract_dir}/sapi/cli/php")
#       # end
#       # 
#       # def is_installed
#       #   File.file?("#{prefix}/bin/php")
#       # end
#       # 
#       # def extension_dir
#       #   Dir["#{prefix}/lib/php/extensions/*"][0]
#       # end
# 
#       # def rake
#       #   super
#       # 
#       #   ["#{self}:configure", "#{self}:force:configure"].map { |t| Rake.application.lookup(t) }.each do |task|
#       #     task.clear_prerequisites.enhance package_depends_on
#       #   end
#       #   
#       #   Rake.application.in_namespace(self.to_sym) do
#       #     task :httpdconf do
#       #       if @sapi == :apache2 and Buildphp::MAMP_MODE then
#       #         sh %[ln -nfs /Applications/MAMP/conf/apache/httpd.conf /Applications/MAMP/Library/conf/httpd.conf]
#       #       end
#       #     end
#       #   end
#       # 
#       #   ["#{self}:install", "#{self}:force:install"].map { |t| Rake.application.lookup(t) }.each do |task|
#       #     task.enhance [:httpdconf] do
#       #       Rake.application["#{self}:ini"].invoke
#       #       Rake.application["#{self}:fastcgi_script"].invoke
#       #     end
#       #   end
#       #   
#       #   Rake.application.in_namespace(self.to_sym) do
#       #     # 
#       #     task :ini do
#       #       if is_installed and not File.file?(php_ini)
#       #         notice "no php.ini detected. installing ..."
#       #         sh %{
#       #           mkdir -p #{config_file_path} #{config_file_scan_dir}
#       #           cp "#{extract_dir}/php.ini-production" "#{php_ini}" || cp "#{extract_dir}/php.ini-recommended" "#{php_ini}"
#       #         }
#       #         notice "enabling compiled modules ..."
#       #         sh %{
#       #           rm -f #{modules_ini}
#       #           echo '; Extension directory (buildphp)' >> #{modules_ini}
#       #           echo 'extension_dir="#{extension_dir}/"' >> #{modules_ini}
#       #           echo '' >> #{modules_ini}
#       #           echo '; Shared modules (buildphp)' >> #{modules_ini}
#       #         }
#       #         FileList["#{extension_dir}/*.so"].map{ |file| File.basename(file) }.each do |file|
#       #           sh "echo 'extension=#{file}' >> #{modules_ini}"
#       #         end
#       # 
#       #         sh %{
#       #           rm -f #{custom_ini}
#       #           echo 'realpath_cache_size = 1024k' >> #{custom_ini}
#       #           echo 'realpath_cache_ttl = 600' >> #{custom_ini}
#       #           echo '' >> #{custom_ini}
#       #           echo 'memory_limit = -1' >> #{custom_ini}
#       #           echo '' >> #{custom_ini}
#       #           echo 'short_open_tag = On' >> #{custom_ini}
#       #         }
#       # 
#       #       end
#       #     end
#       #     #
#       #     task :fastcgi_script do
#       #         # create fastcgi wrapper script
#       #         sh %{
#       #           rm -f #{@prefix}/php5.fcgi
#       #           echo '#!/bin/bash' >> #{@prefix}/php5.fcgi
#       #           echo 'PHPRC="#{config_file_path}"' >> #{@prefix}/php5.fcgi
#       #           echo 'export PHPRC' >> #{@prefix}/php5.fcgi
#       #           echo 'PHP_FCGI_CHILDREN=5' >> #{@prefix}/php5.fcgi
#       #           echo 'export PHP_FCGI_CHILDREN' >> #{@prefix}/php5.fcgi
#       #           echo 'PHP_FCGI_MAX_REQUESTS=5000' >> #{@prefix}/php5.fcgi
#       #           echo 'export PHP_FCGI_MAX_REQUESTS' >> #{@prefix}/php5.fcgi
#       #           echo 'exec "#{@prefix}/bin/php-cgi"' >> #{@prefix}/php5.fcgi
#       #         } if @sapi == :fastcgi
#       #     end
#       #   end
#       # 
#       #   Rake.application[to_sym].clear_prerequisites.enhance(["#{self}:compile"])
#       # end
#     end
#   end 
# end
