# http://us2.php.net/manual/en/intro.json.php
module Buildphp
  module Packages
  class Json < Package
    def php_config_flags
      [
        "--enable-json",
      ]
    end
    
    def rake
      task to_sym
    end
  end
  end
end