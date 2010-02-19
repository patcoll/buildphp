:openssl.version '0.9.8k', :md5 => 'e555c6d58d276aec7fdc53363e338ab3'

package :openssl => [:perl, :zlib] do |openssl|
  openssl.version = '0.9.8k'
  openssl.file = "openssl-#{openssl.version}.tar.gz"
  openssl.location = "http://www.openssl.org/source/#{openssl.file}"
  
  openssl.configure do |c|
    c << './config'
    c << "-I#{Buildphp::INSTALL_TO}/include"
    c << "-L#{Buildphp::INSTALL_TO}/lib"
    c << "-fPIC" if system_is_64_bit?
    c << "--prefix=#{openssl.prefix}"
    c << "zlib-dynamic"
    c << "no-krb5"
    c << "no-asm"
  end
  
  openssl.configure :php do |c|
    c << "--with-openssl=shared,#{openssl.prefix}"
    c << "--with-openssl-dir=#{openssl.prefix}"
  end
  
  openssl.compile_cmd = 'make'
  
  openssl.create_method :is_installed do
    not FileList["#{openssl.prefix}/lib/libssl.*"].empty?
  end
  
  openssl.rake
end
