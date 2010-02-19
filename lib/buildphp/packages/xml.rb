:xml.version '2.6.30', :md5 => '460e6d853e824da700d698532e57316b'

package :xml => [:iconv, :zlib] do
  @version = '2.6.30'
  @file = "libxml2-#{@version}.tar.gz"
  @location = "ftp://ftp.gnome.org/pub/GNOME/sources/libxml2/2.6/#{@file}"
  
  configure do |c|
    c << './configure'
    c << "--with-pic" if is_linux? and system_is_64_bit?
    c << "--prefix=#{@prefix}"
    c << "--with-iconv=#{FACTORY.iconv.prefix}"
    c << "--with-zlib=#{FACTORY.zlib.prefix}"
    c << "--without-python"
  end
  
  configure :php do |c|
    c << "--enable-xml=shared"
    c << "--with-libxml-dir=#{@prefix}"
    c << "--enable-libxml"
    c << "--with-xmlrpc=shared"
    c << "--enable-dom"
    c << "--enable-simplexml"
    c << "--enable-xmlreader"
    c << "--enable-xmlwriter"
  end
  
  def is_installed
    not FileList["#{@prefix}/lib/libxml2.*"].empty?
  end
end
