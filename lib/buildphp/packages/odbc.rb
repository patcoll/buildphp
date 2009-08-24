module Buildphp
  module Packages
    class Odbc < Buildphp::Package
      def initialize
        super
        @version = '2.2.14'
        @versions = {
          '2.2.14' => { :md5 => 'f47c2efb28618ecf5f33319140a7acd0' },
        }
        # @prefix = "/Applications/MAMP/Library"
      end

      def package_depends_on
        [
          'iconv',
        ]
      end

      def package_name
        'unixODBC-%s.tar.gz' % @version
      end

      def package_dir
        'unixODBC-%s' % @version
      end

      def package_location
        'http://www.unixodbc.org/%s' % package_name
      end

      def php_config_flags
        [
          "--with-unixODBC=shared,#{@prefix}",
          "--with-pdo-odbc=shared,unixODBC,#{FACTORY['odbc'].prefix}",
        ]
      end

      def configure_cmd
        parts = []
        parts << flags
        parts << './configure'
        parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
        parts += [
          "--prefix=#{@prefix}",
          "--disable-gui",
          "--enable-iconv",
          "--with-libiconv-prefix=#{FACTORY['iconv'].prefix}",
          "--enable-drivers",
        ]
        parts.join(' ')
      end

      def is_installed
        not FileList["#{@prefix}/lib/libodbc.*"].empty?
      end
    end
  end
end
