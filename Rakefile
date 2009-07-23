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

require 'rake/clean'

CLEAN.add(TMP_DIR+'/*', Dir[EXTRACT_TO+'/*'].delete_if { |path| FileTest.file?(path) }.to_a)
CLEAN.add(EXTRACT_TO + "/#{PhpFpm.filename}.installed") if Php.config[:fpm]

CLOBBER.add(INSTALL_TO+'/*')