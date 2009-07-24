class Mysql < BuildTaskAbstract
  VERSION = '5.1.36'
  
  def versions
    {
      '5.1.36' => { :md5 => '18e694c4ecbe851fe8e21e1668116c46' },
    }
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
      "--with-mysql=shared,#{INSTALL_TO}/mysql",
      "--with-pdo-mysql=shared,#{INSTALL_TO}/mysql",
      "--with-mysqli=shared,#{INSTALL_TO}/mysql/bin/mysql_config",
    ]
  end
  
  def get_build_string
    parts = []
    parts << './configure'
    parts << "--with-pic" if RUBY_PLATFORM == 'x86_64-linux'
    parts += [
      "--prefix=#{INSTALL_TO}/mysql",
      "--with-plugins=max",
      "--with-charset=utf8",
      "--with-collation=utf8_general_ci",
      "--with-extra-charsets=latin1",
      "--without-uca",
    ]
    parts.join(' ')
  end
  
  def is_installed
    File.exists?(File.join(INSTALL_TO, 'mysql', 'include', 'mysql', 'mysql.h'))
  end
end

