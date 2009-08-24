module Buildphp
  module Packages
    class Pear < Buildphp::Package
      def package_depends_on
        [
          'xml',
        ]
      end

      def php_config_flags
        [
          "--with-pear=#{FACTORY['php'].prefix}/share/pear",
        ]
      end

      def rake
        task to_sym => package_depends_on do
          abort "xml must be an included php module to install #{self}" if FACTORY['php'].php_modules.index('xml') == nil
        end
      end
    end
  end
end