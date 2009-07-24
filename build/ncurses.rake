namespace :ncurses do
  task :get do
    FACTORY.get('Ncurses').get()
  end
  
  task :configure => ((FACTORY.get('Ncurses').package_depends_on || []) + [:get]) do
    FACTORY.get('Ncurses').configure()
  end
  
  task :compile => :configure do
    FACTORY.get('Ncurses').compile()
  end
  
  task :install => :compile do
    FACTORY.get('Ncurses').install()
  end
end

task :ncurses => 'ncurses:install'