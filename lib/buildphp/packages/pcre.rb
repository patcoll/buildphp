# http://us2.php.net/manual/en/intro.pcre.php
module Buildphp
  module Packages
    class Pcre < Buildphp::Package
      def php_config_flags
        [
          "--with-pcre-regex",
        ]
      end

      def rake
        task to_sym
      end
    end
  end
end