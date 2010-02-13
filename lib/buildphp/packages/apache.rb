module Buildphp
  module Packages
    class Apache < Buildphp::Package
      def initialize
        super
        @version = '2.2.14'
        @versions = {
          '2.2.14' => { :md5 => '2c1e3c7ba00bcaa0163da7b3e66aaa1e' },
        }
        @prefix = "#{@prefix}/apache2"
      end

      def package_depends_on
        [
          'zlib',
        ]
      end

      def package_name
        'httpd-%s.tar.gz' % @version
      end

      def package_dir
        'httpd-%s' % @version
      end

      def package_location
        'http://www.ecoficial.com/apachemirror/httpd/%s' % package_name
      end

      def get_build_string
        parts = []
        parts << flags
        parts << './configure'
        parts << "--enable-pie" if RUBY_PLATFORM.index("x86_64") != nil
        parts += [
          "--prefix=#{@prefix}",
          "--enable-mods-shared=all",
          "--with-z=#{FACTORY['Zlib'].prefix}",
          "--with-included-apr",
        ]
        parts.join(' ')
      end

      def is_installed
        File.file?("#{@prefix}/bin/apachectl")
      end
    end
  end
end
