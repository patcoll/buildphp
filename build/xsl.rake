namespace :xsl do
  task :get do
    FACTORY.get('Xsl').get()
  end
  
  task :configure => ((FACTORY.get('Xsl').package_depends_on || []) + [:get]) do
    FACTORY.get('Xsl').configure()
  end
  
  task :compile => :configure do
    FACTORY.get('Xsl').compile()
  end
  
  task :install => :compile do
    FACTORY.get('Xsl').install()
  end
end

task :xsl => 'xsl:install'