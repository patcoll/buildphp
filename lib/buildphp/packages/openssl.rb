:openssl.version '0.9.8k', :md5 => 'e555c6d58d276aec7fdc53363e338ab3'

package :openssl => [:perl, :zlib] do
  @version = '0.9.8k'
  @file = "openssl-#{@version}.tar.gz"
  @location = "http://www.openssl.org/source/#{@file}"
  
  configure do |c|
    c << './config'
    c << "-I#{Buildphp::INSTALL_TO}/include"
    c << "-L#{Buildphp::INSTALL_TO}/lib"
    c << "-fPIC" if x86_64?
    c << "--prefix=#{@prefix}"
    c << "zlib-dynamic"
    c << "no-krb5"
    c << "no-asm"
  end
  
  configure :php do |c|
    c << "--with-openssl=shared,#{@prefix}"
    c << "--with-openssl-dir=#{@prefix}"
  end
  
  @compile_cmd = 'make'
  
  def is_installed
    not FileList["#{@prefix}/lib/libssl.*"].empty?
  end
end
