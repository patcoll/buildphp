:freetype.version '2.3.9', :md5 => '9c2744f1aa72fe755adda33663aa3fad'

package :freetype do
  @version = '2.3.9'
  @file = "freetype-#{@version}.tar.gz"
  @location = "http://mirror.its.uidaho.edu/pub/savannah/freetype/#{@file}"
  
  configure do |c|
    c << "./configure"
    c << "--with-pic" if is_linux? and system_is_64_bit?
    c << "--prefix=#{@prefix}"
    c << "--without-zlib"
  end
  
  def is_compiled
    not FileList["#{extract_dir}/objs/*.o"].empty?
  end

  def is_installed
    not FileList["#{@prefix}/lib/libfreetype.*"].empty?
  end
end
