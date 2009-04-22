class Mysql < BuildTaskAbstract
  @prefix = '[mysql] '
  @config = {
    :package => {
      :depends_on => [], # empty array for none.
      :dir => 'mysql-5.1.34',
      :name => 'mysql-5.1.34.tar.gz',
      :location => 'http://mysql.mirrors.pair.com/Downloads/MySQL-5.1/mysql-5.1.34.tar.gz',
      :md5 => '42493187729677cf8f77faeeebd5b3c2'
    },
    :extract => {
      :dir => File.join(Dir.pwd, 'packages', 'mysql-5.1.34')
    }
  }
  class << self
    def get_build_string
      install_dir = BuildTaskAbstract.install_dir
      parts = %w{ ./configure }
      parts << "--prefix=#{install_dir}"
      parts << "--with-plugins=max"
      parts << "--with-charset=utf8"
      parts << "--with-collation=utf8_general_ci"
      parts << "--with-extra-charsets=latin1"
      parts << "--without-uca"
      parts.join(' ')
    end # /get_build_string
    def is_installed
      File.exists?(File.join(BuildTaskAbstract.install_dir, 'include', 'mysql', 'mysql.h'))
    end
  end
end

namespace :mysql do
  task :get do
    Mysql.get()
  end
  
  task :configure => (Mysql.config[:package][:depends_on] + [:get]) do
    Mysql.configure()
  end

  task :compile => :configure do
    Mysql.compile()
  end
  
  task :install => :compile do
    Mysql.install()
  end
end