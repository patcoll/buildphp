:xsl.version '1.1.22', :md5 => 'd6a9a020a76a3db17848d769d6c9c8a9'

package :xsl => :xml do |xsl|
  xsl.version = '1.1.22'
  xsl.file = "libxslt-#{xsl.version}.tar.gz"
  xsl.location = "ftp://ftp.gnome.org/pub/GNOME/sources/libxslt/1.1/#{xsl.file}"
  
  xsl.configure do |c|
    c << './configure'
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{xsl.prefix}"
    c << "--with-libxml-prefix=#{FACTORY.xml.prefix}"
    c << "--with-libxml-include-prefix=#{FACTORY.xml.prefix}/include"
    c << "--with-libxml-libs-prefix=#{FACTORY.xml.prefix}/lib"
    c << "--without-python"
  end
  
  xsl.configure :php do |c|
    c << "--with-xsl=shared,#{xsl.prefix}"
  end
  
  xsl.create_method :is_installed do
    not FileList["#{xsl.prefix}/lib/libxslt.*"].empty?
  end
  
  xsl.rake
end
