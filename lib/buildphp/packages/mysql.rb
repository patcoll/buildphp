:mysql.version '5.1.36', :md5 => '18e694c4ecbe851fe8e21e1668116c46'
:mysql.version '5.1.43', :md5 => '451fd3e8c55eecdf4c3ed109dce62f01'

package :mysql => [:zlib, :ncurses] do |mysql|
  mysql.version = '5.1.43'
  mysql.file = "mysql-#{mysql.version}.tar.gz"
  mysql.location = "ftp://mirror.anl.gov/pub/mysql/Downloads/MySQL-5.1/#{mysql.file}"
  mysql.prefix = "#{mysql.prefix}/mysql"
  
  mysql.configure do |c|
    c << "./configure"
    c << "--with-pic" if system_is_64_bit?
    c << "--prefix=#{mysql.prefix}"
    c << "--with-plugins=max"
    c << "--with-charset=utf8"
    c << "--with-collation=utf8_general_ci"
    c << "--with-extra-charsets=latin1"
    c << "--without-uca"
    c << "--with-zlib-dir=#{FACTORY.zlib.prefix}"
    c << "--with-named-curses-libs=#{FACTORY.ncurses.prefix}/lib/libncurses.a"
  end
  
  mysql.configure :php do |c|
    c << "--with-mysql=shared,#{mysql.prefix}"
    c << "--with-pdo-mysql=shared,#{mysql.prefix}"
    c << "--with-mysqli=shared,#{mysql.prefix}/bin/mysql_config"
  end

  mysql.create_method :is_installed do
    not FileList["#{mysql.prefix}/lib/mysql/libmysqlclient.*"].empty?
  end
  
  mysql.rake
end
