:jpeg.version '7', :md5 => '382ef33b339c299b56baf1296cda9785'

package :jpeg do
  @version = '7'
  @file = "jpegsrc.v#{@version}.tar.gz"
  @location = "http://www.ijg.org/files/#{@file}"
  
  def package_dir
    "jpeg-#{@version}"
  end
  
  configure do |c|
    c << "./configure"
    c << "--with-pic" if is_linux? and system_is_64_bit?
    c << "--prefix=#{@prefix}"
  end

  def is_installed
    not FileList["#{@prefix}/lib/libjpeg.*"].empty?
  end
end
