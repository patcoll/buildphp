:freetype.version '2.3.9', :md5 => '9c2744f1aa72fe755adda33663aa3fad'

package :freetype do |freetype|
  freetype.version = '2.3.9'
  freetype.file = "freetype-#{freetype.version}.tar.gz"
  freetype.location = "http://mirror.its.uidaho.edu/pub/savannah/freetype/#{freetype.file}"
  
  freetype.configure do |c|
    c << "./configure"
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{freetype.prefix}"
    c << "--without-zlib"
  end
  
  freetype.create_method :is_compiled do
    not FileList["#{freetype.extract_dir}/objs/*.o"].empty?
  end

  freetype.create_method :is_installed do
    not FileList["#{freetype.prefix}/lib/libfreetype.*"].empty?
  end
  
  freetype.rake
end
