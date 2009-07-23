class Mysql < BuildTaskAbstract
  VERSION = '5.1.36'
  
  def versions
    {
      '5.1.36' => { :md5 => '18e694c4ecbe851fe8e21e1668116c46' },
    }
  end
  
  def filename
    'mysql-%s.tar.gz'
  end
  
  def dir
    'mysql-%s'
  end
  
  def location
    'http://mysql.mirrors.pair.com/Downloads/MySQL-5.1/%s'
  end
  
  def php_config_flags
    [
      "--with-mysql=shared,#{INSTALL_TO}/mysql",
      "--with-pdo-mysql=shared,#{INSTALL_TO}/mysql",
      "--with-mysqli=shared,#{INSTALL_TO}/mysql/bin/mysql_config",
    ]
  end
  
  def get_build_string
    parts = [
      # flags,
      "./configure",
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
    File.exists?(File.join(INSTALL_TO, 'include', 'mysql', 'mysql.h'))
  end
end

FACTORY.add(Mysql.new(Mysql::VERSION))

namespace :mysql do
  task :get do
    FACTORY.get('Mysql').get()
  end
  
  task :configure => ((FACTORY.get('Mysql').package_depends_on || []) + [:get]) do
    FACTORY.get('Mysql').configure()
  end
  
  task :compile => :configure do
    FACTORY.get('Mysql').compile()
  end
  
  task :install => :compile do
    FACTORY.get('Mysql').install()
  end
  
  task :default => :install
end