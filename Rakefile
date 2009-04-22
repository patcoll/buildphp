File.expand_path(File.join(Dir.pwd, 'vendors'))

ENV['BUILDPHP_EXTRACT_TO'] = File.join(Dir.pwd, 'packages')
ENV['BUILDPHP_INSTALL_TO'] = File.join(Dir.pwd, 'local')

require 'digest/md5'
require 'lib/build_task_abstract'
require 'activesupport'

Inflector = ActiveSupport::Inflector

Dir['build/*/build.rb'].each { |build_script| load build_script }

desc 'Download, configure, build and install PHP and all dependencies'
task :default => ['php:install'] do
end

desc 'Delete all installed files (in local) and extracted archives (folders within packages)'
task :clean do
  # local dir
  to_del = [ENV['BUILDPHP_INSTALL_TO']+'/*']
  # all extracted archives
  to_del += Dir[ENV['BUILDPHP_EXTRACT_TO']+'/*'].delete_if { |path| FileTest.file?(path) }.to_a
  # delete them all!
  sh "rm -rf #{to_del.join(' ')}"  
end