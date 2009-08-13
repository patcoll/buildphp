module Buildphp
  module Packages
  class Mcrypt < Buildphp::Package
    def initialize
      super
      @version = '2.5.8'
      @versions = {
        '2.5.8' => { :md5 => '0821830d930a86a5c69110837c55b7da' },
      }
      # @prefix = "/Applications/MAMP/Library"
    end
  
    def package_name
      'libmcrypt-%s.tar.gz' % @version
    end
  
    def package_dir
      'libmcrypt-%s' % @version
    end
  
    def package_location
      'http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/%s/%s' % [@version, package_name]
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
        "--with-mcrypt=shared,#{@prefix}",
      ]
    end
  
    def is_installed
      not FileList["#{@prefix}/lib/libmcrypt.*"].empty?
    end
  end
  end
end