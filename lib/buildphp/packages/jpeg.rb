:jpeg.version '7', :md5 => '382ef33b339c299b56baf1296cda9785'

package :jpeg do |jpeg|
  jpeg.version = '7'
  jpeg.file = "jpegsrc.v#{jpeg.version}.tar.gz"
  jpeg.location = "http://www.ijg.org/files/#{jpeg.file}"
  
  jpeg.create_method :package_dir do
    "jpeg-#{jpeg.version}"
  end
  
  jpeg.configure do |c|
    c << "./configure"
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{jpeg.prefix}"
  end

  jpeg.create_method :is_installed do
    not FileList["#{jpeg.prefix}/lib/libjpeg.*"].empty?
  end

  jpeg.rake
end
