# http://us2.php.net/manual/en/intro.hash.php
module Buildphp
  module Packages
  class Hash < Package
    def php_config_flags
      [
        "--enable-hash",
      ]
    end
    
    def rake
      task to_sym
    end
  end
  end
end