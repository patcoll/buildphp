# http://www.ijg.org/files/jpegsrc.v7.tar.gz
module Buildphp
  class Jpeg < Package
    PACKAGE_VERSION = '7'
    # PACKAGE_PREFIX = "/Applications/MAMP/Library"
  
    def versions
      {
        '7' => { :md5 => '382ef33b339c299b56baf1296cda9785' },
      }
    end
  
    def package_name
      'jpegsrc.v%s.tar.gz' % @version
    end
  
    def package_dir
      'jpeg-%s' % @version
    end
  
    def package_location
      'http://www.ijg.org/files/%s' % package_name
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
      not FileList["#{@prefix}/lib/libjpeg.*"].empty?
    end
  end
end