module Buildphp
  module Packages
  class Xpm < Buildphp::Package
    def initialize
      super
      @version = '3.5.7'
      @versions = {
        '3.5.7' => { :md5 => '72796ae1412bbab196fee577be61a556' },
      }
      # @prefix = "/Applications/MAMP/Library"
    end
  
    def package_name
      'libXpm-%s-src-11.11.tar.gz' % @version
    end
  
    def package_dir
      'libXpm-%s' % @version
    end
  
    def package_location
      'http://hpux.connect.org.uk/ftp/hpux/X11/Graphics/%s/%s' % [package_dir, package_name]
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
      not FileList["#{extract_dir}/src/*.o"].empty?
    end

    def is_installed
      not FileList["#{@prefix}/lib/libXpm.*"].empty?
    end
  end
  end
end