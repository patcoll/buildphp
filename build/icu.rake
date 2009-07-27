namespace :icu do
  task :get do
    FACTORY.get('Icu').get()
  end
  
  task :configure => ((FACTORY.get('Icu').package_depends_on || []) + [:get]) do
    FACTORY.get('Icu').configure()
  end
  
  task :compile => :configure do
    FACTORY.get('Icu').compile()
  end
  
  task :install => :compile do
    FACTORY.get('Icu').install()
  end
end

task :icu => 'icu:install'