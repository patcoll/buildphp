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
    php = FACTORY.get('Php')
    php_ini = "#{INSTALL_TO}/php5/etc/php.ini"
    install_cmd = %{ make install PHP_PEAR_DOWNLOAD_DIR="#{TMP_DIR}" && make install-cli PHP_PEAR_DOWNLOAD_DIR="#{TMP_DIR}" }
    if php.install(install_cmd) and not File.exists?(php_ini) then
      php.notice "no php.ini detected. installing ..."
      extension_dir = Dir["#{INSTALL_TO}/php5/lib/php/extensions/*"][0]
      sh %{
        cp "#{php.extract_dir}/php.ini-production" "#{php_ini}"
        sed -i.bak -e 's~^; extension_dir = "\./"$~extension_dir = "#{extension_dir}/"~' "#{php_ini}"
      }
      php.notice "enabling compiled modules in new php.ini ..."
      sh %{ echo "" >> #{php_ini} }
      sh %{ echo "; Shared modules (buildphp)" >> #{php_ini} }
      sh %{ echo "" >> #{php_ini} }
      FileList["#{extension_dir}/*.so"].map{ |file| File.basename(file) }.each do |file|
        sh %{ echo "extension=#{file}" >> #{php_ini} }
      end
    end
  end
end

task :php => 'php:install'