module Buildphp
  module Packages
    class PkgConfig < Buildphp::Package
      def initialize
        super
        @version = '0.23'
        @versions = {
          '0.23' => { :md5 => 'd922a88782b64441d06547632fd85744' },
        }
      end

      def package_name
        'pkg-config-%s.tar.gz' % @version
      end

      def package_dir
        'pkg-config-%s' % @version
      end

      def package_location
        'http://pkgconfig.freedesktop.org/releases/%s' % package_name
      end

      def get_build_string
        parts = []
        parts << flags
        parts << './configure'
        parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
        parts << "--prefix=#{@prefix}"
        parts.join(' ')
      end

      def is_installed
        File.file? "#{prefix}/bin/pkg-config"
      end
    end
  end
end
