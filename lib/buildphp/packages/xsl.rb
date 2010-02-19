:xsl.version '1.1.22', :md5 => 'd6a9a020a76a3db17848d769d6c9c8a9'

package :xsl => :xml do
  @version = '1.1.22'
  @file = "libxslt-#{@version}.tar.gz"
  @location = "ftp://ftp.gnome.org/pub/GNOME/sources/libxslt/1.1/#{@file}"
  
  configure do |c|
    c << './configure'
    c << "--with-pic" if is_linux? and system_is_64_bit?
    c << "--prefix=#{@prefix}"
    c << "--with-libxml-prefix=#{FACTORY.xml.prefix}"
    c << "--with-libxml-include-prefix=#{FACTORY.xml.prefix}/include"
    c << "--with-libxml-libs-prefix=#{FACTORY.xml.prefix}/lib"
    c << "--without-python"
  end
  
  configure :php do |c|
    c << "--with-xsl=shared,#{@prefix}"
  end
  
  def is_installed
    not FileList["#{@prefix}/lib/libxslt.*"].empty?
  end
end
