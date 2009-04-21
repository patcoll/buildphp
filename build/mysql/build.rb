

namespace :mysql do
  
  desc 'Get MySQL'
  task :get do
    
  end

  desc 'Configure MySQL'
  task :configure => :get do
    
  end

  desc 'Compile MySQL'
  task :compile => :configure do
    
  end
  
  desc 'Install MySQL'
  task :install => :compile do
    puts 'mysql installed'
  end
end