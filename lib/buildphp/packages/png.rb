:png.version '1.2.38', :md5 => '99900634a47041607a031aa597d51e65'
:png.version '1.2.39', :md5 => 'ddfeaf19b690985910c42e41974e8d65'

package :png => :zlib do |png|
  png.version = '1.2.39'
  png.file = "libpng-#{png.version}.tar.gz"
  png.location = "http://superb-sea2.dl.sourceforge.net/project/libpng/libpng-stable/#{png.version}/#{png.file}"
  
  png.configure do |c|
    c << './configure'
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{png.prefix}"
  end
  
  png.create_method :is_installed do
    not FileList["#{png.prefix}/lib/libpng.*"].empty?
  end
  
  png.rake
end
