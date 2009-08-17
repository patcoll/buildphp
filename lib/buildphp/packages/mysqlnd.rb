module Buildphp
  module Packages
    class Mysqlnd < Buildphp::Package
      def package_depends_on
        [
          'pdo',
        ]
      end

      def php_config_flags
        [
          "--with-mysql=shared,mysqlnd",
          "--with-pdo-mysql=shared,mysqlnd",
          "--with-mysqli=shared,mysqlnd",
        ]
      end

      def rake
        task to_sym
      end
    end
  end
end