module Buildphp
  class Mhash < Package
    PACKAGE_VERSION = '0.9.9.9'
    # PACKAGE_PREFIX = "/Applications/MAMP/Library"
  
    def versions
      {
        '0.9.9.9' => { :md5 => 'ee66b7d5947deb760aeff3f028e27d25' },
      }
    end
  
    def package_name
      'mhash-%s.tar.gz' % @version
    end
  
    def package_dir
      'mhash-%s' % @version
    end
  
    def package_location
      'http://downloads.sourceforge.net/project/mhash/mhash/%s/%s' % [@version, package_name]
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
        "--with-mhash=shared,#{@prefix}",
      ]
    end
  
    def is_installed
      not FileList["#{@prefix}/lib/libmhash.*"].empty?
    end
  end
end