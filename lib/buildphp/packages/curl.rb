module Buildphp
  module Packages
    class Curl < Buildphp::Package
      def initialize
        super
        @version = '7.19.6'
        @versions = {
          '7.19.6' => { :md5 => '6625de9d42d1b8d3af372d3241a576fd' },
        }
      end

      def package_depends_on
        [
          'openssl',
          'zlib',
        ]
      end

      def php_config_flags
        [
          "--with-curl=shared,#{@prefix}"
        ]
      end

      def package_name
        'curl-%s.tar.gz' % @version
      end

      def package_dir
        'curl-%s' % @version
      end

      def package_location
        'http://curl.haxx.se/download/%s' % package_name
      end

      def get_build_string
        parts = []
        parts << flags
        parts << './configure'
        parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
        parts << "--prefix=#{@prefix}"
        parts << "--with-ssl=#{FACTORY['Openssl'].prefix}"
        parts << "--with-zlib=#{FACTORY['zlib'].prefix}"
        parts.join(' ')
      end

      def is_installed
        not FileList["#{@prefix}/lib/libcurl.*"].empty?
      end
    end
  end
end
