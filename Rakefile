BUILDPHP_ROOT = Dir.pwd
TMP_DIR = ENV['BUILDPHP_TMP_DIR'] || File.join(BUILDPHP_ROOT, 'tmp')
EXTRACT_TO = ENV['BUILDPHP_EXTRACT_TO'] || File.join(BUILDPHP_ROOT, 'packages')
INSTALL_TO = ENV['BUILDPHP_INSTALL_TO'] || File.join(BUILDPHP_ROOT, 'local')

require 'digest/md5'
require 'lib/build_task_abstract'
require 'lib/inflect'

Dir['build/*.rb'].each { |build_script| load build_script }

desc 'Download, configure, build and install PHP and all dependencies'
task :default => ['php:install']

desc 'Clean out extracted packages and tmp'
task :clean do
  # tmp dir
  to_del = [TMP_DIR+'/*']
  # all extracted archives
  to_del += Dir[EXTRACT_TO+'/*'].delete_if { |path| FileTest.file?(path) }.to_a
  # delete them all!
  sh "rm -rf #{to_del.join(' ')}"
end

namespace :clean do
  desc "Delete all installed files in #{INSTALL_TO} (only if you know what you're doing)"
  task :installed do
    sh "rm -rf #{INSTALL_TO+'/*'}"
  end
  
  desc "Clean out extracted packages, tmp AND local (only if you know what you're doing)"
  task :all => [:clean, 'clean:installed']
end