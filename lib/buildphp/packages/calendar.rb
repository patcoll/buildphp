# http://us2.php.net/manual/en/intro.calendar.php
module Buildphp
  module Packages
  class Calendar < Buildphp::Package
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
end