:expat.version '2.0.1', :md5 => 'ee8b492592568805593f81f8cdf2a04c'

package :expat do |expat|
  expat.version = '2.0.1'
  expat.file = "expat-#{expat.version}.tar.gz"
  expat.location = "http://downloads.sourceforge.net/project/expat/expat/#{expat.version}/#{expat.file}?use_mirror=voxel"
  
  expat.configure do |c|
    c << "./configure"
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{expat.prefix}"
  end
  
  expat.create_method :is_installed do
    not FileList["#{expat.prefix}/lib/libexpat.*"].empty?
  end
  
  expat.rake
end
