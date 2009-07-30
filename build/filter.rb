# http://us2.php.net/manual/en/intro.filter.php
module Buildphp
  class Filter < Package
    def php_config_flags
      [
        "--enable-filter",
      ]
    end
    
    def rake
      task to_sym
    end
  end
end