:apache.version '2.2.14', :md5 => '2c1e3c7ba00bcaa0163da7b3e66aaa1e'

package :apache => [:openssl, :zlib] do |apache|
  # p "apache rake tasks declared:"
  # p apache.rake_tasks_declared?
  apache.version = '2.2.14'
  apache.file = "httpd-#{apache.version}.tar.gz"
  apache.location = "http://www.ecoficial.com/apachemirror/httpd/#{apache.file}"
  apache.prefix = "#{apache.prefix}/apache2"
  
  apache.configure do |c|
    c << "./configure"
    c << "--enable-pie" if system_is_64_bit?
    c << %W(
      --prefix="#{apache.prefix}"
      --with-included-apr
      --enable-mods-shared=all
      --enable-ssl
      --with-ssl="#{FACTORY.openssl.prefix}"
      --with-z="#{FACTORY.zlib.prefix}"
    )
  end
  
  apache.create_method :is_installed do
    File.file? "#{apache.prefix}/bin/apachectl"
  end
  
  apache.rake
end