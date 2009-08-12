module Buildphp
  class Xml < Package
    def initialize
      super
      @version = '2.6.30'
      @versions = {
        '2.6.30' => { :md5 => '460e6d853e824da700d698532e57316b' },
      }
      # @prefix = "/Applications/MAMP/Library"
    end
  
    def package_depends_on
      [
        'iconv',
        'zlib',
      ]
    end
  
    def package_name
      'libxml2-%s.tar.gz' % @version
    end
  
    def package_dir
      'libxml2-%s' % @version
    end
  
    def package_location
      'ftp://ftp.gnome.org/pub/GNOME/sources/libxml2/2.6/%s' % package_name
    end
  
    def get_build_string
      parts = []
      parts << flags
      parts << './configure'
      parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
      parts << "--prefix=#{@prefix}"
      parts << "--with-iconv=#{@prefix}"
      parts << "--with-zlib=#{@prefix}"
      parts << "--without-python"
      parts.join(' ')
    end
  
    def php_config_flags
      [
        "--enable-xml=shared",
        "--with-libxml-dir=#{@prefix}",
        "--enable-libxml",
        "--with-xmlrpc=shared",
        "--enable-dom",
        "--enable-simplexml",
        "--enable-xmlreader",
        "--enable-xmlwriter",
      ]
    end
  
    def is_installed
      not FileList["#{@prefix}/lib/libxml2.*"].empty?
    end
  end
end