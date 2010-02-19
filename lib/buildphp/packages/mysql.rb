:mysql.version '5.1.36', :md5 => '18e694c4ecbe851fe8e21e1668116c46'
:mysql.version '5.1.43', :md5 => '451fd3e8c55eecdf4c3ed109dce62f01'

package :mysql => [:zlib, :ncurses] do
  @version = '5.1.43'
  @file = "mysql-#{@version}.tar.gz"
  @location = "ftp://mirror.anl.gov/pub/mysql/Downloads/MySQL-5.1/#{@file}"
  @prefix = "#{@prefix}/mysql"
  
  configure do |c|
    c << "./configure"
    c << "--with-pic" if is_linux? and system_is_64_bit?
    c << "--prefix=#{@prefix}"
    c << "--with-plugins=max"
    c << "--with-charset=utf8"
    c << "--with-collation=utf8_general_ci"
    c << "--with-extra-charsets=latin1"
    c << "--without-uca"
    c << "--with-zlib-dir=#{FACTORY.zlib.prefix}"
    c << "--with-named-curses-libs=#{FACTORY.ncurses.prefix}/lib/libncurses.a"
  end
  
  configure :php do |c|
    c << "--with-mysql=shared,#{@prefix}"
    c << "--with-pdo-mysql=shared,#{@prefix}"
    c << "--with-mysqli=shared,#{@prefix}/bin/mysql_config"
  end

  def is_installed
    not FileList["#{@prefix}/lib/mysql/libmysqlclient.*"].empty?
  end
end
