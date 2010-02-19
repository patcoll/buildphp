:mssql.version '0.82', :md5 => '3df6b2e83fd420e90f1becbd1162990a'

package :mssql => :odbc do |mssql|
  mssql.version = '0.82'
  mssql.file = "freetds-#{mssql.version}.tar.gz"
  mssql.location = "http://ibiblio.org/pub/Linux/ALPHA/freetds/stable/#{mssql.file}"
  
  mssql.configure do |c|
    c << "./configure"
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{mssql.prefix}"
    c << "--with-tdsver=8.0"
    c << "--enable-odbc"
    c << "--with-unixodbc=#{FACTORY.odbc.prefix}"
    c << "--disable-libiconv"
    c << "--enable-msdblib"
  end
  
  mssql.configure :php do |c|
    c << "--with-mssql=shared,#{mssql.prefix}"
    c << "--with-pdo-dblib=shared,#{mssql.prefix}"
  end

  mssql.create_method :is_installed do
    not FileList["#{mssql.prefix}/lib/libtdsodbc.*"].empty?
  end
  
  mssql.rake
end
