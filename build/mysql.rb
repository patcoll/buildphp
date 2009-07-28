class Mysql < Package
  PACKAGE_VERSION = '5.1.36'
  # PACKAGE_PREFIX = "#{INSTALL_TO}/mysql"
  # PACKAGE_PREFIX = "/Applications/MAMP/Library"
  
  def versions
    {
      '5.1.36' => { :md5 => '18e694c4ecbe851fe8e21e1668116c46' },
    }
  end
  
  def package_depends_on
    [
      'zlib',
      'ncurses',
    ]
  end
  
  def package_name
    'mysql-%s.tar.gz' % @version
  end
  
  def package_dir
    'mysql-%s' % @version
  end
  
  def package_location
    'http://mysql.mirrors.pair.com/Downloads/MySQL-5.1/%s' % package_name
  end
  
  def php_config_flags
    [
      "--with-mysql=shared,#{PACKAGE_PREFIX}",
      "--with-pdo-mysql=shared,#{PACKAGE_PREFIX}",
      "--with-mysqli=shared,#{PACKAGE_PREFIX}/bin/mysql_config",
    ]
  end
  
  def get_build_string
    parts = []
    parts << flags
    parts << './configure'
    parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
    parts += [
      "--prefix=#{PACKAGE_PREFIX}",
      "--with-plugins=max",
      "--with-charset=utf8",
      "--with-collation=utf8_general_ci",
      "--with-extra-charsets=latin1",
      "--without-uca",
      "--with-zlib-dir=#{Zlib::PACKAGE_PREFIX}",
      "--with-named-curses-libs=#{Ncurses::PACKAGE_PREFIX}/lib/libncurses.a",
    ]
    parts.join(' ')
  end
  
  def is_installed
    not FileList["#{PACKAGE_PREFIX}/lib/mysql/libmysqlclient.*"].empty?
  end
end

