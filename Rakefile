$base_dir = File.dirname(__FILE__)
$:.unshift File.join($base_dir, 'lib')

require 'buildphp'
require 'rake/clean'
require 'rake/packagetask'

package_classes = Buildphp::Packages.constants

# automate instantiation of all package classes
FACTORY = Buildphp::PackageFactory.new
package_classes.each do |class_name|
  klass = Buildphp::Packages.const_get(class_name)
  abort "Could not instantiate #{klass}." if not FACTORY.add(klass.new)
end

# load rake tasks for each package
package_classes.each do |class_name|
  FACTORY.get(class_name).rake
end

desc 'Equivalent to php:compile (requires dependencies)'
task :default => 'php:compile'
desc 'Equivalent to php:install (requires php:compile)'
task :install => 'php:install'

desc 'Install PECL modules (requires PHP install)'
task :pecl => FACTORY.get('php').pecl_modules

Rake::PackageTask.new("buildphp", Buildphp::VERSION) do |p|
  p.need_tar_gz = true
  p.need_tar_bz2 = true
  p.package_files.include %w( lib/**/** * )
end

# clean all "tmp" files and directories in the "packages" directory
CLEAN.add(Buildphp::TMP_DIR+'/*', Dir[Buildphp::EXTRACT_TO+'/*'].delete_if { |path| FileTest.file?(path) }.to_a)

# clean out "installed" status of PHP-FPM
PHPFPM_INSTALL_FILE = Buildphp::EXTRACT_TO + "/#{FACTORY.get('PhpFpm').package_name}.installed"
CLEAN.add(PHPFPM_INSTALL_FILE) if File.exists?(PHPFPM_INSTALL_FILE)

# clobber all installed files in "local"
CLOBBER.add(Buildphp::INSTALL_TO+'/*')