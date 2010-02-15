module Buildphp
  module Packages
    class Perl < Buildphp::Package
      def initialize
        super
        @version = '5.10.1'
        @versions = {
          '5.10.1' => { :md5 => 'b9b2fdb957f50ada62d73f43ee75d044' },
        }
      end

      def package_name
        'perl-%s.tar.gz' % @version
      end

      def package_dir
        'perl-%s' % @version
      end

      def package_location
        'http://www.cpan.org/src/%s' % package_name
      end

      def get_build_string
        parts = []
        parts << flags
        parts << 'sh Configure -de'
        parts << "-fPIC" if RUBY_PLATFORM.index("x86_64") != nil
        parts << "-Dprefix='#{@prefix}'"
        parts.join(' ')
      end

      def is_installed
        File.file? "#{@prefix}/bin/perl"
      end
    end
  end
end
