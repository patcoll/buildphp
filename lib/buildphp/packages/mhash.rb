:mhash.version '0.9.9.9', :md5 => 'ee66b7d5947deb760aeff3f028e27d25'

package :mhash do
  @version = '0.9.9.9'
  @file = "mhash-#{@version}.tar.gz"
  @location = "http://downloads.sourceforge.net/project/mhash/mhash/#{@version}/#{@file}"
  
  configure do |c|
    c << "./configure"
    c << "--with-pic" if x86_64?
    c << "--prefix=#{@prefix}"
  end
  
  configure :php do |c|
    c << "--with-mhash=shared,#{@prefix}"
  end

  def is_installed
    not FileList["#{@prefix}/lib/libmhash.*"].empty?
  end
end
