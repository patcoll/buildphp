:curl.version '7.19.6', :md5 => '6625de9d42d1b8d3af372d3241a576fd'

package :curl => [:pkg_config, :openssl, :zlib] do |curl|
  curl.version = '7.19.6'
  curl.file = "curl-#{curl.version}.tar.gz"
  curl.location = "http://curl.haxx.se/download/#{curl.file}"
  
  curl.configure do |c|
    c << "./configure"
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{curl.prefix}"
    c << "--with-ssl"
    c << "--with-zlib=#{FACTORY.zlib.prefix}"
  end
  
  curl.configure :php do |c|
    c << "--with-curl=shared,#{curl.prefix}"
  end

  curl.create_method :is_installed do
    not FileList["#{curl.prefix}/lib/libcurl.*"].empty?
  end
  
  curl.rake
end
