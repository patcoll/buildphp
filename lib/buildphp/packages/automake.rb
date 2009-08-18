module Buildphp
  module Packages
    class Automake < Buildphp::Package
      def initialize
        super
        @version = '1.11'
        @versions = {
          '1.11' => { :md5 => 'fab0bd2c3990a6679adaf9eeac0c6d2a' },
        }
        # @prefix = "/Applications/MAMP/Library"
      end
      
      def package_depends_on
        [
          'm4',
        ]
      end

      def package_name
        'automake-%s.tar.gz' % @version
      end

      def package_dir
        'automake-%s' % @version
      end

      def package_location
        'http://ftp.gnu.org/gnu/automake/%s' % package_name
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
        File.file?("#{extract_dir}/automake")
      end

      def is_installed
        File.file?("#{@prefix}/bin/automake")
      end
    end
  end
end