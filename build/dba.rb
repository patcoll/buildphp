# http://us2.php.net/manual/en/intro.dba.php
module Buildphp
  module Packages
  class Dba < Package
    def php_config_flags
      [
        "--enable-dba",
        "--with-cdb",
        "--enable-inifile",
        "--enable-flatfile",
      ]
    end
    
    def rake
      task to_sym
    end
  end
  end
end