# http://us2.php.net/manual/en/intro.fileinfo.php
module Buildphp
  module Packages
  class Fileinfo < Buildphp::Package
    def php_config_flags
      [
        "--enable-fileinfo",
      ]
    end
    
    def rake
      task to_sym
    end
  end
  end
end