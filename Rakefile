$:.unshift File.join(File.dirname(__FILE__), 'lib')

BUILDPHP_ROOT = Dir.pwd
TMP_DIR = ENV['BUILDPHP_TMP_DIR'] || File.join(BUILDPHP_ROOT, 'tmp')
EXTRACT_TO = ENV['BUILDPHP_EXTRACT_TO'] || File.join(BUILDPHP_ROOT, 'packages')
INSTALL_TO = ENV['BUILDPHP_INSTALL_TO'] || File.join(BUILDPHP_ROOT, 'local')

require 'buildphp'
require 'rake/clean'

FACTORY = PackageFactory.new

Dir['build/*.rb'].each { |build_script| load build_script }

desc 'Download, configure, build and install PHP and all dependencies'
task :build => ['php:install']
desc 'Download, configure, build and install PHP and all dependencies'
task :default => :build


CLEAN.add(TMP_DIR+'/*', Dir[EXTRACT_TO+'/*'].delete_if { |path| FileTest.file?(path) }.to_a)
CLEAN.add(EXTRACT_TO + "/#{FACTORY.get('PhpFpm').filename}.installed")

CLOBBER.add(INSTALL_TO+'/*')