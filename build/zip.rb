# http://us2.php.net/manual/en/intro.zip.php
module Buildphp
  class Zip < Package
    def php_config_flags
      [
        "--enable-zip=shared",
      ]
    end
    
    def rake
      task to_sym
    end
  end
end