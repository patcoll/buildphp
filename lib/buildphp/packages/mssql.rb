module Buildphp
  module Packages
    class Mssql < Buildphp::Package
      def initialize
        super
        @version = '0.82'
        @versions = {
          '0.82' => { :md5 => '3df6b2e83fd420e90f1becbd1162990a' },
        }
        # @prefix = "#{@prefix}/mysql"
        # @prefix = "/Applications/MAMP/Library"
      end

      def package_depends_on
        [
          'odbc',
        ]
      end

      def package_name
        'freetds-%s.tar.gz' % @version
      end

      def package_dir
        'freetds-%s' % @version
      end

      def package_location
        'http://ibiblio.org/pub/Linux/ALPHA/freetds/stable/%s' % package_name
      end

      def php_config_flags
        [
          "--with-mssql=shared,#{@prefix}",
          "--with-pdo-dblib=shared,#{@prefix}",
        ]
      end

      def configure_cmd
        parts = []
        parts << flags
        parts << './configure'
        parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
        parts += [
          "--prefix=#{@prefix}",
          "--with-tdsver=8.0",
          "--enable-odbc",
          "--with-unixodbc=#{FACTORY.get('odbc').prefix}",
          "--disable-libiconv",
          "--enable-msdblib",
        ]
        parts.join(' ')
      end

      def is_installed
        not FileList["#{@prefix}/lib/libtdsodbc.*"].empty?
      end
    end
  end
end
