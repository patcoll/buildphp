module Buildphp
  module Packages
    class Xsl < Buildphp::Package
      def initialize
        super
        @version = '1.1.22'
        @versions = {
          '1.1.22' => { :md5 => 'd6a9a020a76a3db17848d769d6c9c8a9' },
        }
        # @prefix = "/Applications/MAMP/Library"
      end

      def package_depends_on
        [
          'xml',
        ]
      end

      def package_name
        'libxslt-%s.tar.gz' % @version
      end

      def package_dir
        'libxslt-%s' % @version
      end

      def package_location
        'ftp://ftp.gnome.org/pub/GNOME/sources/libxslt/1.1/%s' % package_name
      end

      def get_build_string
        parts = []
        parts << flags
        parts << './configure'
        parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
        parts << "--prefix=#{@prefix}"
        parts << "--with-libxml-prefix=#{@prefix}"
        parts << "--with-libxml-include-prefix=#{@prefix}/include"
        parts << "--with-libxml-libs-prefix=#{@prefix}/lib"
        parts << "--without-python"
        parts.join(' ')
      end

      def php_config_flags
        [
          "--with-xsl=shared,#{@prefix}",
        ]
      end

      def is_installed
        not FileList["#{@prefix}/lib/libxslt.*"].empty?
      end
    end
  end
end