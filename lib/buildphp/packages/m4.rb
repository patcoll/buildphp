# http://ftp.gnu.org/gnu/m4/m4-1.4.13.tar.gz
module Buildphp
  module Packages
    class M4 < Buildphp::Package
      def initialize
        super
        @version = '1.4.13'
        @versions = {
          '1.4.13' => { :md5 => 'e9e36108b5f9855a82ca4a07ebc0fd2e' },
        }
        # @prefix = "/Applications/MAMP/Library"
      end

      def package_name
        'm4-%s.tar.gz' % @version
      end

      def package_dir
        'm4-%s' % @version
      end

      def package_location
        'http://ftp.gnu.org/gnu/m4/%s' % package_name
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
        File.file?("#{@prefix}/bin/m4")
      end
    end
  end
end