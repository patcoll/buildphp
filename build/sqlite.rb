module Buildphp
  class Sqlite < Package
    def package_depends_on
      [
        'pdo',
      ]
    end
    
    def php_config_flags
      [
        # [BUNDLED]
        "--with-sqlite3",
        "--with-pdo-sqlite",
        "--enable-sqlite-utf8",
      ]
    end
    
    def rake
      task to_sym
    end
  end
end