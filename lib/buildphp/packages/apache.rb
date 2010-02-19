:apache.version '2.2.14', :md5 => '2c1e3c7ba00bcaa0163da7b3e66aaa1e'

package :apache => [:openssl, :zlib] do
  @version = '2.2.14'
  @file = "httpd-#{@version}.tar.gz"
  @location = "http://www.ecoficial.com/apachemirror/httpd/#{@file}"
  @prefix = "#{@prefix}/apache2"
  
  configure do |c|
    c << "./configure"
    c << "--enable-pie" if is_linux? and system_is_64_bit?
    c << %W(
      --prefix="#{@prefix}"
      --with-included-apr
      --enable-mods-shared=all
      --enable-ssl
      --with-ssl="#{FACTORY.openssl.prefix}"
      --with-z="#{FACTORY.zlib.prefix}"
    )
  end
  
  def is_installed
    File.file? "#{@prefix}/bin/apachectl"
  end
end