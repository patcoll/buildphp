module Buildphp
  module Packages
    class Expat < Buildphp::Package
      def initialize
        super
        @version = '2.0.1'
        @versions = {
          '2.0.1' => { :md5 => 'ee8b492592568805593f81f8cdf2a04c' },
        }
        # @prefix = "/Applications/MAMP/Library"
      end

      def package_name
        'expat-%s.tar.gz' % @version
      end

      def package_dir
        'expat-%s' % @version
      end

      def package_location
        'http://downloads.sourceforge.net/project/expat/expat/%s/%s?use_mirror=voxel' % [@version, package_name]
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
        not FileList["#{@prefix}/lib/libexpat.*"].empty?
      end
    end
  end
end