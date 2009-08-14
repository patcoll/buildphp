module Buildphp
  module Packages
  class Memcache < Buildphp::Package
    def initialize
      super
      @version = '2.2.5'
      @versions = {
        '2.2.5' => { :md5 => '72e56a3e4ab5742c4877fd4b6563e9bf' },
      }
    end
    
    def package_depends_on
      [
        'php:install',
      ]
    end
    
    def package_name
      'memcache-%s.tgz' % @version
    end
  
    def package_dir
      'memcache-%s' % @version
    end
  
    def package_location
      'http://pecl.php.net/get/%s' % package_name
    end
    
    def configure_cmd
      "#{FACTORY.get('php').prefix}/bin/phpize && ./configure --enable-#{underscored}"
    end
    
    def install_cmd
      "cp #{extract_dir}/modules/#{underscored}.so #{FACTORY.get('php').extension_dir}/#{underscored}.so"
    end
    
    def is_compiled
      File.file?("#{extract_dir}/modules/#{underscored}.so")
    end
  
    def is_installed
      File.file?("#{FACTORY.get('php').extension_dir}/#{underscored}.so")
    end
    
    def rake
      super
      is_pecl
    end
  end
  end
end