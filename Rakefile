

config = {
  :install_dir => Dir[File.join(Dir.pwd, 'local')][0]
}

packages = {
  :php => 'http://www.php.net/distributions/php-5.2.9.tar.gz',
  :mysql => 'http://mysql.mirrors.pair.com/Downloads/MySQL-5.1/mysql-5.1.33.tar.gz'
}

build = {
  :php => File.join(Dir.pwd, 'build', 'php', 'src'),
  :mysql => File.join(Dir.pwd, 'build', 'mysql', 'src')
}

desc 'Validation'
namespace :validate do
  desc 'Validate presence of all remote packages'
  task :packages do
    
  end
end

desc 'PHP'
namespace :php do
  desc 'Grab PHP from the server'
  task :get do
    Dir.mkdir(build[:php]) unless File.exist?(build[:php])
    Dir.chdir(build[:php]) do
      sh "wget #{packages[:php]}"
      sh "tar xfz #{File.basename(packages[:php])}"
      # puts 
      # `rm -rf #{packages[:php]}`
    end
  end
  
  desc 'Configure PHP'
  task :configure => (%w{
    mysql:install
  } + [:get]) do
    require File.join(build[:php], '../', 'build.rb')
    Dir.chdir(File.join(build[:php], get_dir_name(packages[:php]))) do
      # puts Dir.pwd
      # puts get_build_string(config[:install_dir])
      `#{get_build_string(config[:install_dir])}`
    end
  end

  desc 'Compile PHP'
  task :compile => :configure do
    
  end
  
  desc 'Install PHP'
  task :install => :compile do
    `rm -rf #{File.join(build[:php], '*')}`
  end
end

def get_dir_name(path)
  first = File.basename(path, File.extname(File.basename(path)))
  # first
  second = File.basename(first, File.extname(first))
  second
end

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