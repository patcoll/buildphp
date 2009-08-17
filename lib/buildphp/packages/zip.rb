# http://us2.php.net/manual/en/intro.zip.php
module Buildphp
  module Packages
    class Zip < Buildphp::Package
      def package_depends_on
        [
          'zlib',
        ]
      end

      def php_config_flags
        [
          "--enable-zip=shared",
          "--with-zlib-dir=#{FACTORY.get('zlib').prefix}",
        ]
      end

      def rake
        task to_sym
      end
    end
  end
end