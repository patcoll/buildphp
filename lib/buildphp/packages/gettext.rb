module Buildphp
  module Packages
    class Gettext < Buildphp::Package
      def initialize
        super
        @version = '0.17'
        @versions = {
          '0.17' => { :md5 => '58a2bc6d39c0ba57823034d55d65d606' },
        }
        # @prefix = "/Applications/MAMP/Library"
      end

      def package_depends_on
        [
          'expat',
          'iconv',
          'ncurses',
          'xml',
        ]
      end

      def package_name
        'gettext-%s.tar.gz' % @version
      end

      def package_dir
        'gettext-%s' % @version
      end

      def package_location
        'http://ftp.gnu.org/pub/gnu/gettext/%s' % package_name
      end

      def get_build_string
        parts = []
        parts << flags
        parts << './configure'
        parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
        parts << "--prefix=#{@prefix}"
        parts << "--disable-java"
        parts << "--disable-native-java"
        parts << "--disable-threads"
        parts << "--with-libexpat-prefix=#{FACTORY['expat'].prefix}"
        parts << "--with-libiconv-prefix=#{FACTORY['iconv'].prefix}"
        parts << "--with-libncurses-prefix=#{FACTORY['ncurses'].prefix}"
        parts << "--with-libxml2-prefix=#{FACTORY['xml'].prefix}"
        parts.join(' ')
      end

      def php_config_flags
        [
          "--with-gettext=shared,#{@prefix}",
        ]
      end

      def is_installed
        not FileList["#{@prefix}/lib/libgettextlib.*"].empty?
      end
    end
  end
end