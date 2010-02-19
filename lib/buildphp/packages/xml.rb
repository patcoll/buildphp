:xml.version '2.6.30', :md5 => '460e6d853e824da700d698532e57316b'

package :xml => [:iconv, :zlib] do |xml|
  xml.version = '2.6.30'
  xml.file = "libxml2-#{xml.version}.tar.gz"
  xml.location = "ftp://ftp.gnome.org/pub/GNOME/sources/libxml2/2.6/#{xml.file}"
  
  xml.configure do |c|
    c << './configure'
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{xml.prefix}"
    c << "--with-iconv=#{FACTORY.iconv.prefix}"
    c << "--with-zlib=#{FACTORY.zlib.prefix}"
    c << "--without-python"
  end
  
  xml.configure :php do |c|
    c << "--enable-xml=shared"
    c << "--with-libxml-dir=#{xml.prefix}"
    c << "--enable-libxml"
    c << "--with-xmlrpc=shared"
    c << "--enable-dom"
    c << "--enable-simplexml"
    c << "--enable-xmlreader"
    c << "--enable-xmlwriter"
  end
  
  xml.create_method :is_installed do
    not FileList["#{xml.prefix}/lib/libxml2.*"].empty?
  end
  
  xml.rake
end
