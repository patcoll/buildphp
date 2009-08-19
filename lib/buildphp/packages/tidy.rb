module Buildphp
  module Packages
    class Tidy < Buildphp::Package
      def php_config_flags
        [
          "--with-tidy=shared",
        ]
      end

      def rake
        task to_sym
      end
    end
  end
end