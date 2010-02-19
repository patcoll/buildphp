:expat.version '2.0.1', :md5 => 'ee8b492592568805593f81f8cdf2a04c'

package :expat do
  @version = '2.0.1'
  @file = "expat-#{@version}.tar.gz"
  @location = "http://downloads.sourceforge.net/project/expat/expat/#{@version}/#{@file}?use_mirror=voxel"
  
  configure do |c|
    c << "./configure"
    c << "--with-pic" if is_linux? and system_is_64_bit?
    c << "--prefix=#{@prefix}"
  end

  def is_installed
    not FileList["#{@prefix}/lib/libexpat.*"].empty?
  end
end
