# http://us2.php.net/manual/en/ref.bc.php
module Buildphp
  class Bcmath < Package
    def php_config_flags
      [
        "--enable-bcmath",
      ]
    end
    
    def rake
      task to_sym
    end
  end
end