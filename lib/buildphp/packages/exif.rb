# http://us2.php.net/manual/en/intro.exif.php
module Buildphp
  module Packages
    class Exif < Buildphp::Package
      def php_config_flags
        [
          "--enable-exif",
        ]
      end

      def rake
        task to_sym
      end
    end
  end
end