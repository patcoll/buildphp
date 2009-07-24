namespace :php_fpm do
  task :get do
    FACTORY.get('PhpFpm').get()
  end
end

task :php_fpm => 'php_fpm:get'