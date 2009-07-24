namespace :libtool do
  task :get do
    FACTORY.get('Libtool').get()
  end
  
  task :configure => ((FACTORY.get('Libtool').package_depends_on || []) + [:get]) do
    FACTORY.get('Libtool').configure()
  end
  
  task :compile => :configure do
    FACTORY.get('Libtool').compile()
  end
  
  task :install => :compile do
    FACTORY.get('Libtool').install()
  end
end

task :libtool => 'libtool:install'