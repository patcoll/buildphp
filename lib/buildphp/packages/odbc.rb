:odbc.version '2.2.14', :md5 => 'f47c2efb28618ecf5f33319140a7acd0'

package :odbc => :iconv do
  @version = '2.2.14'
  @file = "unixODBC-#{@version}.tar.gz"
  @location = "http://www.unixodbc.org/#{@file}"
  
  configure do |c|
    c << "./configure"
    c << "--with-pic" if x86_64?
    c << "--prefix=#{@prefix}"
    c << "--disable-gui"
    c << "--enable-iconv"
    c << "--with-libiconv-prefix=#{FACTORY.iconv.prefix}"
    c << "--enable-drivers"
  end
  
  configure :php do |c|
    c << "--with-unixODBC=shared,#{@prefix}"
    c << "--with-pdo-odbc=shared,unixODBC,#{@prefix}"
  end
  
  def is_installed
    not FileList["#{@prefix}/lib/libodbc.*"].empty?
  end
end
