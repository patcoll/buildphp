:php.version '5.2.10', :md5 => '85753ba2909ac9fae5bca516adbda9e9'
:php.version '5.3.0',  :md5 => 'f4905eca4497da3f0beb5c96863196b4'
:php.version '5.3.1',  :md5 => '41fbb368d86acb13fc3519657d277681'

package :php => %w(bz2 curl gd gettext iconv mcrypt mhash mssql odbc openssl pear pcre soap xml xsl zlib zip) do
  @version = '5.3.1'
  @file = "php-#{@version}.tar.gz"
  @location = "http://www.php.net/get/#{@file}/from/this/mirror"
  @prefix = "#{@prefix}/php5"

  add_attr :fpm, :sapi, :build_apache
  fpm = false
  sapi = :apache2
  build_apache = true
  depends_on.unshift 'apache' if build_apache
  
  # mysql driver
  depends_on << 'mysqlnd' # or 'mysql'
  depends_on.sort!
  # depends_on << 'php:get'
  # p depends_on
  
  def sapi_flags
    flags = []
    if sapi == :apache2
      if Buildphp::MAMP_MODE
        flags << "--with-apxs2=/Applications/MAMP/Library/bin/apxs"
      elsif build_apache
        flags << "--with-apxs2=#{FACTORY.apache.prefix}/bin/apxs"
      else
        flags << "--with-apxs2"
      end
    elsif sapi == :fastcgi
      flags << "--enable-fastcgi"
      flags << "--enable-discard-path"
      flags << "--enable-force-cgi-redirect"
    end
    flags
  end
  # p sapi_flags
  
  add_attr :config_file_path, :config_file_scan_dir, :php_ini
  config_file_path = "#{@prefix}/etc"
  config_file_scan_dir = "#{config_file_path}/php.d"
  php_ini = "#{config_file_path}/php.ini"
  
  def custom_ini(name='defaults')
    "#{config_file_scan_dir}/#{name}.ini"
  end
  # p custom_ini
  # p custom_ini 'asd'
  
  def modules_ini
    custom_ini 'modules'
  end
  # p modules_ini
  
  configure do |parts|
    parts << './configure'
    parts << "--with-pic" if x86_64?
    parts << "--with-gnu-ld"

    # add configuration flags based on which interface we're building
    parts << sapi_flags

    # core PHP options
    parts << %W(
      --prefix="#{@prefix}"
      --with-config-file-path="#{config_file_path}"
      --with-config-file-scan-dir="#{config_file_scan_dir}"
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
  # puts configure_cmd
  
  # configure :apache do |c|
  #   c << '--apache'
  #   c << '--configure'
  #   c << '--flags'
  # end
  
  @install_cmd = %{make install PHP_PEAR_DOWNLOAD_DIR="#{Buildphp::TMP_DIR}" && make install-cli PHP_PEAR_DOWNLOAD_DIR="#{Buildphp::TMP_DIR}"}
  
  def is_installed
    File.file?("#{@prefix}/bin/php")
  end

  # p is_installed
  
  def is_compiled
    File.file?("#{extract_dir}/sapi/cli/php")
  end
  
  def is_installed
    File.file?("#{@prefix}/bin/php")
  end
  
  def extension_dir
    Dir["#{@prefix}/lib/php/extensions/*"][0]
  end
  
  # Custom rake actions.
  rake do
    Rake.application.in_namespace(to_sym) do
      task :httpdconf do
        if sapi == :apache2 and Buildphp::MAMP_MODE then
          sh %[ln -nfs /Applications/MAMP/conf/apache/httpd.conf /Applications/MAMP/Library/conf/httpd.conf]
        end
      end
    end

    ["#{self}:install", "#{self}:force:install"].map { |t| Rake.application.lookup(t) }.each do |task|
      task.enhance [:httpdconf] do
        Rake.application["#{self}:ini"].invoke
        Rake.application["#{self}:fastcgi_script"].invoke
      end
    end

    Rake.application.in_namespace(to_sym) do
      # 
      task :ini do
        if is_installed and not File.file?(php_ini)
          notice "no php.ini detected. installing ..."
          sh %{
            mkdir -p #{config_file_path} #{config_file_scan_dir}
            cp "#{extract_dir}/php.ini-production" "#{php_ini}" || cp "#{extract_dir}/php.ini-recommended" "#{php_ini}"
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

        end
      end

      task :fastcgi_script do
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
          } if sapi == :fastcgi
      end
    end
    # make the "php" task alias to "php:compile" instead of "php:install" (the default)
    Rake.application[to_sym].clear_prerequisites.enhance(["#{self}:compile"])
  end # /rake
end
