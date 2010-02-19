require 'rake'
require 'buildphp/constants'
require 'buildphp/inflect'
require 'buildphp/package'
require 'buildphp/package_factory'
require 'buildphp/version'

FileUtils.mkdir_p [Buildphp::INSTALL_TO, Buildphp::EXTRACT_TO, Buildphp::TMP_DIR]
FACTORY = Buildphp::PackageFactory.new

def package(name)
  if name.is_a?(String)
    name = name
  elsif name.is_a?(Hash)
    sh = name.shift
    name = sh[0]
    unless sh[1].nil?
      depends_on = [sh[1]] if sh[1].is_a?(String) or sh[1].is_a?(Symbol)
      depends_on = sh[1] if sh[1].is_a?(Array)
    end
  end

  name = name.to_s
  depends_on.map! { |dp| dp.to_s } unless depends_on.nil?

  pkg = FACTORY[name]
  inject_new = false
  if pkg.nil?
    pkg = Buildphp::Package.new
    pkg.name = name
    inject_new = true
  end
  pkg.depends_on += depends_on if depends_on.is_a?(Array)

  yield pkg if block_given?
  abort 'must provide a package name' if pkg.name.nil?
  # abort "must provide a version for package #{pkg.name}" if pkg.version.nil?
  # puts "#{pkg.name} => [#{pkg.depends_on.join(', ')}]"
  # puts "  version: #{pkg.version}"

  if inject_new
    FACTORY[pkg.name] = pkg
  end
  # p pkg.name
  # unless pkg.rake_tasks_declared?
  #   pkg.rake
  # end
  # p pkg.rake_tasks_declared?
end

# def method_missing(symbol, *args)
#   Dir[File.expand_path(File.join(File.dirname(__FILE__), "buildphp/packages/#{symbol}.rb"))].each do |t|
#     p t
#     require t
#   end
#   FACTORY[symbol.to_s]
# end

# package :newpkg do |pkg|
#   pkg.version = '1.0'
# end

# package 'asd' do |pkg|
#   pkg.version = '1.2'
# end

# package 'asd' => 'a'
# package 'asd' => 's'
# package 'asd' => 'as'
# p FACTORY['asd']

# p FACTORY.to_a
# p FACTORY.to_hash
# p FACTORY['php']
# p FACTORY['hi']

def system_is_64_bit?
  system("sysctl hw.cpu64bit_capable > /dev/null 2>&1")
end

module VersionShortcut
  def version(version, opts={})
    package self.to_s do |p|
      p.versions[version] = opts
    end
  end
end

class String
  include VersionShortcut
end

class Symbol
  include VersionShortcut
end

Dir[File.expand_path(File.join(File.dirname(__FILE__), 'buildphp/packages/*.rb'))].each do |t|
  pkg = File.basename(t).chomp(File.extname(t))
  package pkg
  require t
  # FACTORY[pkg].rake
end

# abort
