module Buildphp
  module Packages
    class Php < Buildphp::Package
      attr_reader :fpm
      attr_reader :sapi
      attr_accessor :php_modules

      def initialize
        super
        @version = '5.3.1'
        @versions = {
          '5.2.6' => { :md5 => '1720f95f26c506338f0dba3a51906bbd' },
          '5.2.8' => { :md5 => 'e748cace3cfecb66fb6de9a945f98e2a' },
          '5.2.9' => { :md5 => '98b647561dc664adefe296106056cf11' },
          '5.2.10' => { :md5 => '85753ba2909ac9fae5bca516adbda9e9' },
          '5.3.0' => { :md5 => 'f4905eca4497da3f0beb5c96863196b4' },
          '5.3.1' => { :md5 => '41fbb368d86acb13fc3519657d277681' },
        }
        # install prefix
        @prefix = "#{@prefix}/php5"
        # enable PHP-FPM? -- http://php-fpm.org/
        # TODO: update build script for newest PHP-FPM version, which is a separate compile now, not a patch.
        @fpm = false
        ### php modules to enable.
        ### all optional.
        @php_modules = [
          ### built-ins.
          ### these packages have code which is packaged with the PHP core distribution.
          'bcmath', # For arbitrary precision mathematics PHP offers the Binary Calculator which supports numbers of any size and precision, represented as strings.
          'calendar', # The calendar extension presents a series of functions to simplify converting between different calendar formats.
          'ctype', # The functions provided by this extension check whether a character or string falls into a certain character class according to the current locale (see also setlocale()).
          'dba', # These functions build the foundation for accessing Berkeley DB style databases.
          'exif', # With the exif extension you are able to work with image meta data. For example, you may use exif functions to read meta data of pictures taken from digital cameras by working with information stored in the headers of the JPEG and TIFF images.
          'fileinfo', # The functions in this module try to guess the content type and encoding of a file by looking for certain magic byte sequences at specific positions within the file. While this is not a bullet proof approach the heuristics used do a very good job.
          'filter', # This extension filters data by either validating or sanitizing it. This is especially useful when the data source contains unknown (or foreign) data, like user supplied input. For example, this data may come from an HTML form.
          'hash', # Message Digest (hash) engine. Allows direct or incremental processing of arbitrary length messages using a variety of hashing algorithms.
          'iconv', # This module contains an interface to iconv character set conversion facility.
          'json', # This extension implements the JavaScript Object Notation (JSON) data-interchange format.
          'mbstring', # mbstring provides multibyte specific string functions that help you deal with multibyte encodings in PHP.
          'mysqlnd', # builtin mysql native php driver
          'pear', # requires xml explicitly (uncomment the xml line below)
          'pcre', # Perl-compatible regular expressions. The syntax for patterns used in these functions closely resembles Perl.
          'sqlite', # This is an extension for the SQLite Embeddable SQL Database Engine.
          # 
          # ### these packages require external libs.
          # ### only put packages here if PHP has a direct dependency on the package.
          # ### a good example of this is "png" which only the "gd" package has a direct dependency on.
          'bz2', # The bzip2 functions are used to transparently read and write bzip2 (.bz2) compressed files.
          'curl', # PHP supports libcurl, a library created by Daniel Stenberg, that allows you to connect and communicate to many different types of servers with many different types of protocols.
          'gd', # PHP can output image streams directly to a browser. You will need to compile PHP with the GD library of image functions for this to work. requires iconv, freetype, jpeg, png, zlib, xpm
          'gettext', # The gettext functions implement an NLS (Native Language Support) API which can be used to internationalize your PHP applications. requires expat, iconv, ncurses, xml
          'mcrypt', # This is an interface to the mcrypt library, which supports a wide variety of block algorithms
          'mhash', # This is an interface to the mhash library. mhash supports a wide variety of hash algorithms such as MD5, SHA1, GOST, and many others.
          # 'mysql', # not needed if 'mysqlnd' is included from above. requires zlib, ncurses.
          'mssql', # These functions allow you to access MS SQL Server database.
          'odbc',
          # 'openssl',
          'soap', # requires xml. The SOAP extension can be used to write SOAP Servers and Clients. It supports subsets of SOAP 1.1, SOAP 1.2 and WSDL 1.1 specifications.
          'xml', # requires iconv, zlib
          'xsl', # requires xml
          'zlib',
          'zip', # requires zlib

          ### not yet implemented
          # 'imap',
          # 'ldap',
        ]

        # which interface to build?
        # supported options:
        #   :apache2
        #   :fastcgi
        @sapi = :apache2

        # build apache as a dependency?
        @build_apache = true
      end
      
      def pecl_modules
        FACTORY.packages.find_all { |package| package.is_pecl }
      end

      def sapi_flags
        flags = []
        if @sapi == :apache2
          if Buildphp::MAMP_MODE
            flags << "--with-apxs2=/Applications/MAMP/Library/bin/apxs"
          elsif @build_apache
            flags << "--with-apxs2=#{FACTORY['Apache'].prefix}/bin/apxs"
          else
            flags << "--with-apxs2"
          end
        elsif @sapi == :fastcgi
          flags << "--enable-fastcgi"
          flags << "--enable-discard-path"
          flags << "--enable-force-cgi-redirect"
        end
        return flags
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
        dependencies = [:m4, :autoconf, :automake, :libtool] + php_modules + ["#{self}:get"]
        dependencies << 'php_fpm' if fpm
        dependencies << 'apache' if @build_apache
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
          "--enable-spl",
          "--enable-short-tags",
          "--enable-tokenizer",
          "--enable-zend-multibyte",
        ]

        # PHP-FPM
        parts += FACTORY['php_fpm'].php_config_flags if fpm

        # Extensions that depend on external libraries
        # Get config flags from dependencies
        php_modules.map { |ext| Inflect.camelize(ext) }.each do |ext|
          parts += FACTORY[ext].php_config_flags || []
        end

        parts.join(' ')
      end

      def install_cmd
        %[make install PHP_PEAR_DOWNLOAD_DIR="#{Buildphp::TMP_DIR}" && make install-cli PHP_PEAR_DOWNLOAD_DIR="#{Buildphp::TMP_DIR}"]
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

        ["#{self}:configure", "#{self}:force:configure"].map { |t| Rake.application.lookup(t) }.each do |task|
          task.clear_prerequisites.enhance package_depends_on
        end
        
        Rake.application.in_namespace(self.to_sym) do
          task :httpdconf do
            if @sapi == :apache2 and Buildphp::MAMP_MODE then
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
        
        Rake.application.in_namespace(self.to_sym) do
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
          #
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
              } if @sapi == :fastcgi
          end
        end

        Rake.application[to_sym].clear_prerequisites.enhance(["#{self}:compile"])
      end
    end
  end 
end
