module Buildphp
  class Mysql < Package
    def initialize
      super
      @version = '5.1.36'
      @versions = {
        '5.1.36' => { :md5 => '18e694c4ecbe851fe8e21e1668116c46' },
      }
      @prefix = "#{INSTALL_TO}/mysql"
      # @prefix = "/Applications/MAMP/Library"
    end
  
    def package_depends_on
      [
        'zlib',
        'ncurses',
        'pdo',
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
        "--with-mysql=shared,#{@prefix}",
        "--with-pdo-mysql=shared,#{@prefix}",
        "--with-mysqli=shared,#{@prefix}/bin/mysql_config",
      ]
    end
  
    def get_build_string
      parts = []
      parts << flags
      parts << './configure'
      parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
      parts += [
        "--prefix=#{@prefix}",
        "--with-plugins=max",
        "--with-charset=utf8",
        "--with-collation=utf8_general_ci",
        "--with-extra-charsets=latin1",
        "--without-uca",
        "--with-zlib-dir=#{FACTORY.get('Zlib').prefix}",
        "--with-named-curses-libs=#{FACTORY.get('Ncurses').prefix}/lib/libncurses.a",
      ]
      parts.join(' ')
    end
  
    def is_installed
      not FileList["#{@prefix}/lib/mysql/libmysqlclient.*"].empty?
    end
  end
end
