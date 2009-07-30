module Buildphp
  class PhpFpm < Package
    PACKAGE_VERSION = '5.3.0'
  
    def versions
      {
        '5.2.8' => { :md5 => '7104c76e2891612af636104e0f6d60d4' },
        '5.3.0' => { :md5 => 'ed0c29aa55a2d233cd9be6ece3ad1ba1' },
      }
    end
  
    def package_name
      options = {
        '5.3.0' => 'php-5.3.0-fpm-0.5.12-rc.diff.gz',
        '5.2.8' => 'php-5.2.8-fpm-0.5.10.diff.gz',
      }
      options[@version]
    end
  
    def package_location
      "http://php-fpm.org/downloads/%s" % package_name
    end
  
    def extract_dir
      false
    end
  
    def extract_cmd
      "gzip -cd #{package_name} | patch -d #{FACTORY.get('Php').package_dir} -p1 && echo '' > #{package_name}.installed"
    end
  
    def php_config_flags
      [
        "--enable-fpm",
      ]
    end

    def is_installed
      File.exists?(File.join(EXTRACT_TO, "#{package_name}.installed"))
    end
  
    def rake
      task to_sym do
        get
      end
    end
  end
end
