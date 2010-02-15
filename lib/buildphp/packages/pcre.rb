# http://us2.php.net/manual/en/intro.pcre.php
module Buildphp
  module Packages
    class Pcre < Buildphp::Package
      def initialize
        super
        @version = '8.01'
        @versions = {
          '8.01' => { :md5 => 'def40e944d2c429cbf563357e61c1ad2' },
        }
      end

      def package_name
        'pcre-%s.tar.gz' % @version
      end

      def package_dir
        'pcre-%s' % @version
      end

      def package_location
        'http://downloads.sourceforge.net/project/pcre/pcre/%s/%s?use_mirror=cdnetworks-us-1' % [@version, package_name]
      end

      def get_build_string
        parts = []
        parts << flags
        parts << './configure'
        parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
        parts << "--prefix=#{@prefix}"
        parts << "--enable-utf8"
        parts << "--enable-unicode-properties"
        parts.join(' ')
      end

      def is_installed
        not FileList["#{@prefix}/lib/libpcre.*"].empty?
      end
      
      def php_config_flags
        [
          "--with-pcre-regex=#{@prefix}",
          "--with-pcre-dir=#{@prefix}",
        ]
      end
    end
  end
end