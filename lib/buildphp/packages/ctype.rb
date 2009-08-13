# http://us2.php.net/manual/en/intro.ctype.php
module Buildphp
  module Packages
  class Ctype < Buildphp::Package
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
end