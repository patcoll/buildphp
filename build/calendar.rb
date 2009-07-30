# http://us2.php.net/manual/en/intro.calendar.php
module Buildphp
  class Calendar < Package
    def php_config_flags
      [
        "--enable-calendar",
      ]
    end
    
    def rake
      task to_sym
    end
  end
end