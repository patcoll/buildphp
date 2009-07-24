namespace :mysql do
  task :get do
    FACTORY.get('Mysql').get()
  end
  
  task :configure => ((FACTORY.get('Mysql').package_depends_on || []) + [:get]) do
    FACTORY.get('Mysql').configure()
  end
  
  task :compile => :configure do
    FACTORY.get('Mysql').compile()
  end
  
  task :install => :compile do
    FACTORY.get('Mysql').install()
  end
end

task :mysql => 'mysql:install'