class Mysql < BuildTaskAbstract
  @filename = 'mysql-5.1.34.tar.gz'
  @dir = 'mysql-5.1.34'
  @config = {
    :package => {
      :dir => dir,
      :name => filename,
      :location => "http://mysql.mirrors.pair.com/Downloads/MySQL-5.1/#{filename}",
      :md5 => '42493187729677cf8f77faeeebd5b3c2',
    },
    :extract => {
      :dir => File.join(EXTRACT_TO, dir),
    },
    :php_config_flags => [
      "--with-mysql=shared,#{INSTALL_TO}",
      "--with-pdo-mysql=shared,#{INSTALL_TO}",
      "--with-mysqli=shared,#{INSTALL_TO}/bin/mysql_config",
    ],
  }
  class << self
    def get_build_string
      parts = %w{ ./configure }
      parts << "--prefix=#{INSTALL_TO}"
      parts << "--with-plugins=max"
      parts << "--with-charset=utf8"
      parts << "--with-collation=utf8_general_ci"
      parts << "--with-extra-charsets=latin1"
      parts << "--without-uca"
      parts.join(' ')
    end # /get_build_string
    def is_installed
      File.exists?(File.join(INSTALL_TO, 'include', 'mysql', 'mysql.h'))
    end
  end
end

namespace :mysql do
  task :get do
    Mysql.get()
  end
  
  task :configure => ((Mysql.config[:package][:depends_on] || []) + [:get]) do
    Mysql.configure()
  end

  task :compile => :configure do
    Mysql.compile()
  end
  
  task :install => :compile do
    Mysql.install()
  end
end