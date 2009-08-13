$:.unshift File.join(File.dirname(__FILE__), 'lib')

TMP_DIR = ENV['BUILDPHP_TMP_DIR'] || File.join(File.dirname(__FILE__), 'tmp')
EXTRACT_TO = ENV['BUILDPHP_EXTRACT_TO'] || File.join(File.dirname(__FILE__), 'src')
INSTALL_TO = ENV['BUILDPHP_INSTALL_TO'] || File.join(File.dirname(__FILE__), 'local')

require 'buildphp'
require 'rake/clean'
require 'rake/packagetask'

# MAMP_MODE = ENV['MAMP'] # TODO: implement MAMP compatibility mode that would link the PHP build against libraries included with MAMP

Dir['build/*.rb'].each { |build_task| require build_task }
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
  p.package_files.include %w( build/*.rb lib/**/** local src tmp * )
end

# clean all "tmp" files and directories in the "packages" directory
CLEAN.add(Buildphp::TMP_DIR+'/*', Dir[Buildphp::EXTRACT_TO+'/*'].delete_if { |path| FileTest.file?(path) }.to_a)

# clean out "installed" status of PHP-FPM
PHPFPM_INSTALL_FILE = Buildphp::EXTRACT_TO + "/#{FACTORY.get('PhpFpm').package_name}.installed"
CLEAN.add(PHPFPM_INSTALL_FILE) if File.exists?(PHPFPM_INSTALL_FILE)

# clobber all installed files in "local"
CLOBBER.add(Buildphp::INSTALL_TO+'/*')