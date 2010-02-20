:mcrypt.version '2.5.8', :md5 => '0821830d930a86a5c69110837c55b7da'

package :mcrypt do
  @version = '2.5.8'
  @file = "libmcrypt-#{@version}.tar.gz"
  @location = "http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/#{@version}/#{@file}"
  
  configure do |c|
    c << "./configure"
    c << "--with-pic" if x86_64?
    c << "--prefix=#{@prefix}"
  end
  
  configure :php do |c|
    c << "--with-mcrypt=shared,#{@prefix}"
  end

  def is_installed
    not FileList["#{@prefix}/lib/libmcrypt.*"].empty?
  end
end
