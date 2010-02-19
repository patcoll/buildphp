:curl.version '7.19.6', :md5 => '6625de9d42d1b8d3af372d3241a576fd'

package :curl => [:pkg_config, :openssl, :zlib] do
  @version = '7.19.6'
  @file = "curl-#{@version}.tar.gz"
  @location = "http://curl.haxx.se/download/#{@file}"
  
  configure do |c|
    c << "./configure"
    c << "--with-pic" if is_linux? and system_is_64_bit?
    c << "--prefix=#{@prefix}"
    c << "--with-ssl"
    c << "--with-zlib=#{FACTORY.zlib.prefix}"
  end
  
  configure :php do |c|
    c << "--with-curl=shared,#{@prefix}"
  end

  def is_installed
    not FileList["#{@prefix}/lib/libcurl.*"].empty?
  end
end
