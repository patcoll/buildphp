$:.unshift File.join(File.dirname(__FILE__), 'lib')

TMP_DIR = ENV['BUILDPHP_TMP_DIR'] || File.join(File.dirname(__FILE__), 'tmp')
EXTRACT_TO = ENV['BUILDPHP_EXTRACT_TO'] || File.join(File.dirname(__FILE__), 'packages')
INSTALL_TO = ENV['BUILDPHP_INSTALL_TO'] || File.join(File.dirname(__FILE__), 'local')

require 'buildphp'
require 'rake/clean'

FACTORY = PackageFactory.new
oldconst = Module.constants
Dir['build/*.rb'].each { |build_task| load build_task }
newconst = Module.constants

# automate instantiation of all classes that extend BuildTaskAbstract
(newconst - oldconst).each do |class_name|
  klass = Module.const_get(class_name)
  abort "Could not instantiate #{klass}." if not FACTORY.add(klass.new(klass::PACKAGE_VERSION))
end

Dir['build/*.rake'].each { |rake_task| load rake_task }

desc 'Download, configure, build and install PHP and all dependencies'
task :build => :php
desc 'Download, configure, build and install PHP and all dependencies'
task :default => :build

# clean all "tmp" files and directories in the "packages" directory
CLEAN.add(TMP_DIR+'/*', Dir[EXTRACT_TO+'/*'].delete_if { |path| FileTest.file?(path) }.to_a)
# clean out "installed" status of PHP-FPM
PHPFPM_INSTALL_FILE = EXTRACT_TO + "/#{FACTORY.get('PhpFpm').package_name}.installed"
CLEAN.add(PHPFPM_INSTALL_FILE) if File.exists?(PHPFPM_INSTALL_FILE)

# clobber all installed files in "local"
CLOBBER.add(INSTALL_TO+'/*')