module Buildphp
  module Packages
    class Apc < Buildphp::Package
      def initialize
        super
        @version = '3.1.3p1'
        @versions = {
          '3.0.19' => { :md5 => '951f43d2873e3572f5d5ae71a9b66f90' },
          '3.1.3p1' => { :md5 => '941cf59c3f8042c1d6961b7afb1002b9' }
        }
        @is_pecl = true
      end

      def package_depends_on
        [
          'php:install',
        ]
      end

      def package_name
        'APC-%s.tgz' % @version
      end

      def package_dir
        'APC-%s' % @version
      end

      def package_location
        'http://pecl.php.net/get/%s' % package_name
      end

      def configure_cmd
        %[export PHP_PREFIX="#{FACTORY['php'].prefix}" && $PHP_PREFIX/bin/phpize && ./configure --enable-#{self}=shared --with-php-config=$PHP_PREFIX/bin/php-config]
      end

      def is_compiled
        File.file?("#{extract_dir}/modules/#{self}.so")
      end

      def is_installed
        File.file?("#{FACTORY['php'].extension_dir}/#{self}.so")
      end

      def rake
        super
        build_as_addon if @is_pecl
      end
    end
  end
end