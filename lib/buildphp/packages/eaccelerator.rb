module Buildphp
  module Packages
    class Eaccelerator < Buildphp::Package
      def initialize
        super
        @version = '0.9.6-rc1'
        @versions = {
          '0.9.5.3' => { :md5 => '' },
          '0.9.6-rc1' => { :md5 => 'af078c6cfb57fcd4fafaccbdd14cc05c' },
        }
        @is_pecl = true
      end
    
      def package_depends_on
        [
          'php:install',
        ]
      end
    
      def package_name
        'eaccelerator-%s.tar.bz2' % @version
      end
    
      def extract_cmd
        "tar xfj %s" % package_name
      end
  
      def package_dir
        'eaccelerator-%s' % @version
      end
  
      def package_location
        'http://bart.eaccelerator.net/source/0.9.6/%s' % package_name
      end
    
      def configure_cmd
        %[export PHP_PREFIX="#{FACTORY.get('php').prefix}" && $PHP_PREFIX/bin/phpize && ./configure --enable-#{underscored}=shared --with-php-config=$PHP_PREFIX/bin/php-config]
      end
    
      def is_compiled
        File.file?("#{extract_dir}/modules/#{underscored}.so")
      end
  
      def is_installed
        File.file?("#{FACTORY.get('php').extension_dir}/#{underscored}.so")
      end
      
      def rake
        super
        build_as_addon if @is_pecl
      end
    end
  end
end