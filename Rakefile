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
  FACTORY.get(class_name).rake if FACTORY.get(class_name).respond_to?(:rake)
end

desc 'Download, configure and build PHP and install all dependencies'
task :default => :php
desc 'Download, configure, build and install PHP and all dependencies'
task :install => 'php:install'

Rake::PackageTask.new("buildphp", Buildphp::VERSION) do |p|
  # p.package_dir = 'dist'
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