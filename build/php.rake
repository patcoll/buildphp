namespace :php do
  task :get do
    FACTORY.get('Php').get()
  end
  
  task :configure => FACTORY.get('Php').package_depends_on do
    FACTORY.get('Php').configure()
  end

  task :compile => :configure do
    FACTORY.get('Php').compile()
  end
  
  task :install => :compile do
    FACTORY.get('Php').install("make install PHP_PEAR_DOWNLOAD_DIR=\"#{TMP_DIR}\" && make install-cli PHP_PEAR_DOWNLOAD_DIR=\"#{TMP_DIR}\"")
  end
end

task :php => 'php:install'