# http://us2.php.net/manual/en/intro.ctype.php
module Buildphp
  class Ctype < Package
    def php_config_flags
      [
        "--enable-ctype",
      ]
    end
    
    def rake
      task to_sym
    end
  end
end