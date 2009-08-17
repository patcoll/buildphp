# http://us2.php.net/manual/en/ref.bc.php
module Buildphp
  module Packages
    class Bcmath < Buildphp::Package
      def php_config_flags
        [
          "--enable-bcmath",
        ]
      end

      def rake
        task to_sym
      end
    end
  end
end