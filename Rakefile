$:.unshift File.join(File.dirname(__FILE__), 'lib')

# the folder where we'll handle local, src and tmp
$base_dir = File.dirname(__FILE__)

require 'buildphp'
require 'rake/clean'
require 'rake/packagetask'

desc 'Equivalent to php:compile (requires dependencies)'
task :default => 'php:compile'
desc 'Equivalent to php:install (requires php:compile)'
task :install => 'php:install'

# desc 'List PECL or add-on modules available to install (requires PHP install)'
# task :pecl do
#   puts "To install and activate any of the following modules, run `rake <module>`"
#   p FACTORY['php'].pecl_modules.map { |m| m.to_s }
# end
# 
# namespace :pecl do
#   desc "Install all available PECL or add-on modules"
#   task :install_all => FACTORY['php'].pecl_modules.map { |m| m.to_s }
# end

Rake::PackageTask.new("buildphp", Buildphp::VERSION) do |p|
  p.need_tar_gz = true
  p.need_tar_bz2 = true
  p.package_files.include %w( lib/**/** * )
end

# clean all "tmp" files and directories in the "packages" directory
CLEAN.add(Buildphp::TMP_DIR+'/*', Dir[Buildphp::EXTRACT_TO+'/*'].delete_if { |path| File.file?(path) }.to_a)

# clean out "installed" status of PHP-FPM
# PHPFPM_INSTALL_FILE = Buildphp::EXTRACT_TO + "/#{FACTORY['php_fpm'].package_name}.installed"
# CLEAN.add(PHPFPM_INSTALL_FILE) if File.exists?(PHPFPM_INSTALL_FILE)

# clobber all installed files in "local"
CLOBBER.add(Buildphp::INSTALL_TO+'/*')
