$:.unshift File.join(File.dirname(__FILE__), 'lib')

TMP_DIR = ENV['BUILDPHP_TMP_DIR'] || File.join(File.dirname(__FILE__), 'tmp')
EXTRACT_TO = ENV['BUILDPHP_EXTRACT_TO'] || File.join(File.dirname(__FILE__), 'packages')
INSTALL_TO = ENV['BUILDPHP_INSTALL_TO'] || File.join(File.dirname(__FILE__), 'local')
MAMP_MODE = ENV['MAMP']

require 'buildphp'
require 'rake/clean'

FACTORY = Buildphp::PackageFactory.new
oldmods = Buildphp.constants
Dir['build/*.rb'].each { |build_task| load build_task }
newmods = Buildphp.constants
package_classes = (newmods - oldmods)

# automate instantiation of all package classes
package_classes.each do |class_name|
  klass = Buildphp.const_get(class_name)
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

# clean all "tmp" files and directories in the "packages" directory
CLEAN.add(TMP_DIR+'/*', Dir[EXTRACT_TO+'/*'].delete_if { |path| FileTest.file?(path) }.to_a)

# clean out "installed" status of PHP-FPM
PHPFPM_INSTALL_FILE = EXTRACT_TO + "/#{FACTORY.get('PhpFpm').package_name}.installed"
CLEAN.add(PHPFPM_INSTALL_FILE) if File.exists?(PHPFPM_INSTALL_FILE)

# clobber all installed files in "local"
CLOBBER.add(INSTALL_TO+'/*')