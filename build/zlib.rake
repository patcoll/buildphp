namespace :zlib do
  task :get do
    FACTORY.get('Zlib').get()
  end
  
  task :configure => ((FACTORY.get('Zlib').package_depends_on || []) + [:get]) do
    FACTORY.get('Zlib').configure()
  end
  
  task :compile => :configure do
    FACTORY.get('Zlib').compile()
  end
  
  task :install => :compile do
    FACTORY.get('Zlib').install()
  end
end

task :zlib => 'zlib:install'