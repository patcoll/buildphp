namespace :xml do
  task :get do
    FACTORY.get('Xml').get()
  end
  
  task :configure => ((FACTORY.get('Xml').package_depends_on || []) + [:get]) do
    FACTORY.get('Xml').configure()
  end
  
  task :compile => :configure do
    FACTORY.get('Xml').compile()
  end
  
  task :install => :compile do
    FACTORY.get('Xml').install()
  end
end

task :xml => 'xml:install'