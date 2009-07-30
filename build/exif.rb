# http://us2.php.net/manual/en/intro.exif.php
module Buildphp
  class Exif < Package
    def php_config_flags
      [
        "--enable-exif",
      ]
    end
    
    def rake
      task to_sym
    end
  end
end