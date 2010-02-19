:mhash.version '0.9.9.9', :md5 => 'ee66b7d5947deb760aeff3f028e27d25'

package :mhash do |mhash|
  mhash.version = '0.9.9.9'
  mhash.file = "mhash-#{mhash.version}.tar.gz"
  mhash.location = "http://downloads.sourceforge.net/project/mhash/mhash/#{mhash.version}/#{mhash.file}"
  
  mhash.configure do |c|
    c << "./configure"
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{mhash.prefix}"
  end
  
  mhash.configure :php do |c|
    c << "--with-mhash=shared,#{mhash.prefix}"
  end

  mhash.create_method :is_installed do
    not FileList["#{mhash.prefix}/lib/libmhash.*"].empty?
  end
  
  mhash.rake
end
