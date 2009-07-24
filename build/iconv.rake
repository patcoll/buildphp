namespace :iconv do
  task :get do
    FACTORY.get('Iconv').get()
  end
  
  task :configure => ((FACTORY.get('Iconv').package_depends_on || []) + [:get]) do
    FACTORY.get('Iconv').configure()
  end
  
  task :compile => :configure do
    FACTORY.get('Iconv').compile()
  end
  
  task :install => :compile do
    FACTORY.get('Iconv').install()
  end
end

task :iconv => 'iconv:install'