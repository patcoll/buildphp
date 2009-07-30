# http://www.libgd.org/releases/gd-2.0.35.tar.gz
module Buildphp
  class Gd < Package
    PACKAGE_VERSION = '2.0.35'
    # PACKAGE_PREFIX = "/Applications/MAMP/Library"
  
    def versions
      {
        '2.0.35' => { :md5 => '982963448dc36f20cb79b6e9ba6fdede' },
      }
    end
  
    def package_depends_on
      [
        'iconv',
        'freetype',
        'jpeg',
        'png',
        'zlib',
        # 'xpm',
      ]
    end
  
    def package_name
      'gd-%s.tar.gz' % @version
    end
  
    def package_dir
      'gd-%s' % @version
    end
  
    def package_location
      'http://www.libgd.org/releases/%s' % package_name
    end
  
    def get_build_string
      parts = []
      parts << flags
      parts << './configure'
      parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
      parts << "--prefix=#{@prefix}"
      parts << "--with-libiconv-prefix=#{FACTORY.get('Iconv').prefix}"
      parts << "--with-freetype=#{FACTORY.get('Freetype').prefix}"
      parts << "--with-jpeg=#{FACTORY.get('Jpeg').prefix}"
      parts << "--with-png=#{FACTORY.get('Png').prefix}"
      # parts << "--with-xpm=#{FACTORY.get('Xpm').prefix}"
      parts.join(' ')
    end
  
    def php_config_flags
      [
        "--with-gd=shared,#{@prefix}",
        "--with-freetype-dir=#{FACTORY.get('Freetype').prefix}",
        "--with-jpeg-dir=#{FACTORY.get('Jpeg').prefix}",
        "--with-png-dir=#{FACTORY.get('Png').prefix}",
        "--with-zlib-dir=#{FACTORY.get('Zlib').prefix}",
        # "--with-xpm-dir=#{FACTORY.get('Xpm').prefix}",
      ]
    end
  
    def is_installed
      not FileList["#{@prefix}/lib/libgd.*"].empty?
    end
  end
end