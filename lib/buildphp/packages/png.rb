:png.version '1.2.38', :md5 => '99900634a47041607a031aa597d51e65'
:png.version '1.2.39', :md5 => 'ddfeaf19b690985910c42e41974e8d65'

package :png => :zlib do
  @version = '1.2.39'
  @file = "libpng-#{@version}.tar.gz"
  @location = "http://superb-sea2.dl.sourceforge.net/project/libpng/libpng-stable/#{@version}/#{@file}"
  
  configure do |c|
    c << './configure'
    c << "--with-pic" if is_linux? and system_is_64_bit?
    c << "--prefix=#{@prefix}"
  end
  
  def is_installed
    not FileList["#{@prefix}/lib/libpng.*"].empty?
  end
end
