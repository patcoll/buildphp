$:.unshift File.join(File.dirname(__FILE__), 'lib')

TMP_DIR = ENV['BUILDPHP_TMP_DIR'] || File.join(File.dirname(__FILE__), 'tmp')
EXTRACT_TO = ENV['BUILDPHP_EXTRACT_TO'] || File.join(File.dirname(__FILE__), 'packages')
INSTALL_TO = ENV['BUILDPHP_INSTALL_TO'] || File.join(File.dirname(__FILE__), 'local')

require 'buildphp'
require 'rake/clean'

FACTORY = PackageFactory.new

Dir['build/*.rb'].each { |build_task| load build_task }

# TODO: automate instantiation of all classes that (directly) extend BuildTaskAbstract
FACTORY.add(Bz2.new(Bz2::VERSION))
FACTORY.add(Iconv.new(Iconv::VERSION))
FACTORY.add(Mysql.new(Mysql::VERSION))
FACTORY.add(Php.new(Php::VERSION))
FACTORY.add(PhpFpm.new(Php::VERSION))
FACTORY.add(Xml.new(Xml::VERSION))

Dir['build/*.rake'].each { |rake_task| load rake_task }

desc 'Download, configure, build and install PHP and all dependencies'
task :build => :php
desc 'Download, configure, build and install PHP and all dependencies'
task :default => :build


CLEAN.add(TMP_DIR+'/*', Dir[EXTRACT_TO+'/*'].delete_if { |path| FileTest.file?(path) }.to_a)
CLEAN.add(EXTRACT_TO + "/#{FACTORY.get('PhpFpm').package_name}.installed")

CLOBBER.add(INSTALL_TO+'/*')