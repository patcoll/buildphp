module Buildphp
  module Packages
    class Freetype < Buildphp::Package
      def initialize
        super
        @version = '2.3.9'
        @versions = {
          '2.3.9' => { :md5 => '9c2744f1aa72fe755adda33663aa3fad' },
        }
        # @prefix = "/Applications/MAMP/Library"
      end

      def package_name
        'freetype-%s.tar.gz' % @version
      end

      def package_dir
        'freetype-%s' % @version
      end

      def package_location
        'http://mirror.its.uidaho.edu/pub/savannah/freetype/%s' % package_name
      end

      def get_build_string
        parts = []
        parts << flags
        parts << './configure'
        parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
        parts << "--prefix=#{@prefix}"
        parts << "--without-zlib"
        parts.join(' ')
      end

      def is_compiled
        not FileList["#{extract_dir}/objs/*.o"].empty?
      end

      def is_installed
        not FileList["#{@prefix}/lib/libfreetype.*"].empty?
      end
    end
  end
end