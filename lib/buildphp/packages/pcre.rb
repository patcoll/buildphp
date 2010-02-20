:pcre.version '8.01', :md5 => 'def40e944d2c429cbf563357e61c1ad2'

package :pcre do
  @version = '8.01'
  @file = "pcre-#{@version}.tar.gz"
  @location = "http://downloads.sourceforge.net/project/pcre/pcre/#{@version}/#{@file}?use_mirror=cdnetworks-us-1"
  
  configure do |c|
    c << './configure'
    c << "--with-pic" if x86_64?
    c << "--prefix=#{@prefix}"
    c << "--enable-utf8"
    c << "--enable-unicode-properties"
  end
  
  configure :php do |c|
    c << "--with-pcre-regex=#{@prefix}"
    c << "--with-pcre-dir=#{@prefix}"
  end
  
  def is_installed
    not FileList["#{@prefix}/lib/libpcre.*"].empty?
  end
end
