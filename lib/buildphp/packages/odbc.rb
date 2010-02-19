:odbc.version '2.2.14', :md5 => 'f47c2efb28618ecf5f33319140a7acd0'

package :odbc => :iconv do |odbc|
  odbc.version = '2.2.14'
  odbc.file = "unixODBC-#{odbc.version}.tar.gz"
  odbc.location = "http://www.unixodbc.org/#{odbc.file}"
  
  odbc.configure do |c|
    c << "./configure"
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{odbc.prefix}"
    c << "--disable-gui"
    c << "--enable-iconv"
    c << "--with-libiconv-prefix=#{FACTORY.iconv.prefix}"
    c << "--enable-drivers"
  end
  
  odbc.configure :php do |c|
    c << "--with-unixODBC=shared,#{odbc.prefix}"
    c << "--with-pdo-odbc=shared,unixODBC,#{odbc.prefix}"
  end
  
  odbc.create_method :is_installed do
    not FileList["#{odbc.prefix}/lib/libodbc.*"].empty?
  end
  
  odbc.rake
end
