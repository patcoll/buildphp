module Buildphp
  module Packages
    class Autoconf < Buildphp::Package
      def initialize
        super
        @version = '2.64'
        @versions = {
          '2.64' => { :md5 => '30a198cef839471dd4926e92ab485361' },
        }
        # @prefix = "/Applications/MAMP/Library"
      end
      
      def package_depends_on
        [
          'm4',
        ]
      end

      def package_name
        'autoconf-%s.tar.gz' % @version
      end

      def package_dir
        'autoconf-%s' % @version
      end

      def package_location
        'http://ftp.gnu.org/gnu/autoconf/%s' % package_name
      end

      def get_build_string
        parts = []
        parts << flags
        parts << './configure'
        parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
        parts << "--prefix=#{@prefix}"
        parts.join(' ')
      end
      
      def is_compiled
        File.file?("#{extract_dir}/bin/autoconf")
      end

      def is_installed
        File.file?("#{@prefix}/bin/autoconf")
      end
    end
  end
end