module Buildphp
  module Packages
  class Iconv < Buildphp::Package
    def initialize
      super
      @version = '1.12'
      @versions = {
        '1.12' => { :md5 => 'c2be282595751535a618ae0edeb8f648' },
      }
      # @prefix = "/Applications/MAMP/Library"
    end
  
    def package_name
      'libiconv-%s.tar.gz' % @version
    end
  
    def package_dir
      'libiconv-%s' % @version
    end
  
    def package_location
      'http://ftp.gnu.org/pub/gnu/libiconv/%s' % package_name
    end
  
    def get_build_string
      parts = []
      parts << flags
      parts << './configure'
      parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
      parts << "--prefix=#{@prefix}"
      parts.join(' ')
    end
  
    def php_config_flags
      [
        "--with-iconv=shared",
        "--with-iconv-dir=#{@prefix}",
      ]
    end
  
    def is_compiled
      not FileList["#{extract_dir}/src/*.o"].empty?
    end
  
    def is_installed
      not FileList["#{@prefix}/lib/libiconv.*"].empty?
    end
  end
  end
end