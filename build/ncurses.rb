module Buildphp
  class Ncurses < Package
    def initialize
      super
      @version = '5.7'
      @versions = {
        '5.7' => { :md5 => 'cce05daf61a64501ef6cd8da1f727ec6' },
      }
      # @prefix = '/usr'
    end
  
    def package_depends_on
      [
        'libtool',
      ]
    end
  
    def package_name
      'ncurses-%s.tar.gz' % @version
    end
  
    def package_dir
      'ncurses-%s' % @version
    end
  
    def package_location
      'http://ftp.gnu.org/pub/gnu/ncurses/%s' % package_name
    end
  
    def get_build_string
      parts = []
      parts << flags
      parts << './configure'
      parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
      parts << "--prefix=#{@prefix}"
      parts << "--without-debug"
      parts << "--with-shared"
      # disable c++ support
      # parts << "--without-cxx"
      # parts << "--without-cxx-binding"
      parts << "--with-libtool"
      parts << "--enable-termcap"
      parts.join(' ')
    end
  
    def is_compiled
      not FileList["#{extract_dir}/**/*.lo"].empty?
    end
  
    def is_installed
      not FileList["#{@prefix}/lib/libncurses.*"].empty?
    end
  end
end