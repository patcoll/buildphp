# http://www.libgd.org/releases/gd-2.0.35.tar.gz
module Buildphp
  module Packages
    class Gd < Buildphp::Package
      def initialize
        super
        @version = '2.0.35'
        @versions = {
          '2.0.35' => { :md5 => '982963448dc36f20cb79b6e9ba6fdede' },
        }
        # @prefix = "/Applications/MAMP/Library"
      end

      def package_depends_on
        [
          'iconv',
          'freetype',
          'jpeg',
          'png',
          'zlib',
          # 'xpm',
        ]
      end

      def package_name
        'gd-%s.tar.gz' % @version
      end

      def package_dir
        'gd-%s' % @version
      end

      def package_location
        'http://www.libgd.org/releases/%s' % package_name
      end

      def get_build_string
        parts = []
        parts << flags
        parts << './configure'
        parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
        parts << "--prefix=#{@prefix}"
        parts << "--with-libiconv-prefix=#{FACTORY['iconv'].prefix}"
        parts << "--with-freetype=#{FACTORY['freetype'].prefix}"
        parts << "--with-jpeg=#{FACTORY['jpeg'].prefix}"
        parts << "--with-png=#{FACTORY['png'].prefix}"
        # parts << "--with-xpm=#{FACTORY['xpm'].prefix}"
        parts.join(' ')
      end

      def php_config_flags
        [
          "--with-gd=shared,#{@prefix}",
          "--with-freetype-dir=#{FACTORY['freetype'].prefix}",
          "--with-jpeg-dir=#{FACTORY['jpeg'].prefix}",
          "--with-png-dir=#{FACTORY['png'].prefix}",
          "--with-zlib-dir=#{FACTORY['zlib'].prefix}",
          # "--with-xpm-dir=#{FACTORY['xpm'].prefix}",
        ]
      end

      def is_installed
        not FileList["#{@prefix}/lib/libgd.*"].empty?
      end
    end
  end
end