module Buildphp
  module Packages
    class Png < Buildphp::Package
      def initialize
        super
        @version = '1.2.39'
        @versions = {
          '1.2.38' => { :md5 => '99900634a47041607a031aa597d51e65' },
          '1.2.39' => { :md5 => 'ddfeaf19b690985910c42e41974e8d65' },
        }
        # @prefix = "/Applications/MAMP/Library"
      end
      
      def package_depends_on
        [
          'zlib',
        ]
      end

      def package_name
        'libpng-%s.tar.gz' % @version
      end

      def package_dir
        'libpng-%s' % @version
      end

      def package_location
        'http://superb-sea2.dl.sourceforge.net/project/libpng/libpng-stable/%s/%s' % [@version, package_name]
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
        not FileList["#{@prefix}/lib/libpng.*"].empty?
      end
    end
  end
end