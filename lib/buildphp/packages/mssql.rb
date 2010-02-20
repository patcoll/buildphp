:mssql.version '0.82', :md5 => '3df6b2e83fd420e90f1becbd1162990a'

package :mssql => :odbc do
  @version = '0.82'
  @file = "freetds-#{@version}.tar.gz"
  @location = "http://ibiblio.org/pub/Linux/ALPHA/freetds/stable/#{@file}"
  
  configure do |c|
    c << "./configure"
    c << "--with-pic" if x86_64?
    c << "--prefix=#{@prefix}"
    c << "--with-tdsver=8.0"
    c << "--enable-odbc"
    c << "--with-unixodbc=#{FACTORY.odbc.prefix}"
    c << "--disable-libiconv"
    c << "--enable-msdblib"
  end
  
  configure :php do |c|
    c << "--with-mssql=shared,#{@prefix}"
    c << "--with-pdo-dblib=shared,#{@prefix}"
  end

  def is_installed
    not FileList["#{@prefix}/lib/libtdsodbc.*"].empty?
  end
end
