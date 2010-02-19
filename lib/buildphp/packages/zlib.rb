:zlib.version '1.2.3', :md5 => 'debc62758716a169df9f62e6ab2bc634'

package :zlib do |zlib|
  zlib.version = '1.2.3'
  zlib.file = "zlib-#{zlib.version}.tar.gz"
  zlib.location = "http://www.zlib.net/#{zlib.file}"
  
  zlib.configure do |c|
    c << './configure'
    c << "--shared"
    c << "--prefix=#{zlib.prefix}"
  end
  
  zlib.configure :php do |c|
    c << "--enable-zip=shared"
    c << "--with-zlib=shared"
    c << "--with-zlib-dir=#{zlib.prefix}"
  end
  
  zlib.create_method :is_installed do
    not FileList["#{zlib.prefix}/lib/libz.*"].empty?
  end
  
  zlib.rake
end
