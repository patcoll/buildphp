:zlib.version '1.2.3', :md5 => 'debc62758716a169df9f62e6ab2bc634'

package :zlib do
  @version = '1.2.3'
  @file = "zlib-#{@version}.tar.gz"
  @location = "http://www.zlib.net/#{@file}"
  
  configure do |c|
    c << './configure'
    c << "--shared"
    c << "--prefix=#{@prefix}"
  end
  
  configure :php do |c|
    c << "--enable-zip=shared"
    c << "--with-zlib=shared"
    c << "--with-zlib-dir=#{@prefix}"
  end
  
  def is_installed
    not FileList["#{@prefix}/lib/libz.*"].empty?
  end
end
