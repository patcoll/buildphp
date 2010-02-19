:pcre.version '8.01', :md5 => 'def40e944d2c429cbf563357e61c1ad2'

package :pcre do |pcre|
  pcre.version = '8.01'
  pcre.file = "pcre-#{pcre.version}.tar.gz"
  pcre.location = "http://downloads.sourceforge.net/project/pcre/pcre/#{pcre.version}/#{pcre.file}?use_mirror=cdnetworks-us-1"
  
  pcre.configure do |c|
    c << './configure'
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{pcre.prefix}"
    c << "--enable-utf8"
    c << "--enable-unicode-properties"
  end
  
  pcre.configure :php do |c|
    c << "--with-pcre-regex=#{pcre.prefix}"
    c << "--with-pcre-dir=#{pcre.prefix}"
  end
  
  pcre.create_method :is_installed do
    not FileList["#{pcre.prefix}/lib/libpcre.*"].empty?
  end
  
  pcre.rake
end
