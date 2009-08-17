module Buildphp
  module Packages
    class Memcache < Buildphp::Package
      def initialize
        super
        @version = '2.2.5'
        @versions = {
          '2.2.5' => { :md5 => '72e56a3e4ab5742c4877fd4b6563e9bf' },
        }
        @is_pecl = true
      end

      def package_depends_on
        [
          'php:install',
        ]
      end

      def package_name
        'memcache-%s.tgz' % @version
      end

      def package_dir
        'memcache-%s' % @version
      end

      def package_location
        'http://pecl.php.net/get/%s' % package_name
      end

      def configure_cmd
        %[export PHP_PREFIX="#{FACTORY.get('php').prefix}" && $PHP_PREFIX/bin/phpize && ./configure --enable-#{self}=shared --with-php-config=$PHP_PREFIX/bin/php-config]
      end

      def is_compiled
        File.file?("#{extract_dir}/modules/#{self}.so")
      end

      def is_installed
        File.file?("#{FACTORY.get('php').extension_dir}/#{self}.so")
      end

      def rake
        super
        build_as_addon if @is_pecl
      end
    end
  end
end