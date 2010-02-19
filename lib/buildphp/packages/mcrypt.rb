:mcrypt.version '2.5.8', :md5 => '0821830d930a86a5c69110837c55b7da'

package :mcrypt do |mcrypt|
  mcrypt.version = '2.5.8'
  mcrypt.file = "libmcrypt-#{mcrypt.version}.tar.gz"
  mcrypt.location = "http://downloads.sourceforge.net/project/mcrypt/Libmcrypt/#{mcrypt.version}/#{mcrypt.file}"
  
  mcrypt.configure do |c|
    c << "./configure"
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{mcrypt.prefix}"
  end
  
  mcrypt.configure :php do |c|
    c << "--with-mcrypt=shared,#{mcrypt.prefix}"
  end

  mcrypt.create_method :is_installed do
    not FileList["#{mcrypt.prefix}/lib/libmcrypt.*"].empty?
  end
  
  mcrypt.rake
end
