require 'rake'
require 'buildphp/constants'
require 'buildphp/inflect'
require 'buildphp/package'
require 'buildphp/package_factory'
require 'buildphp/version'

FileUtils.mkdir_p [Buildphp::INSTALL_TO, Buildphp::EXTRACT_TO, Buildphp::TMP_DIR]
FACTORY = Buildphp::PackageFactory.new

def package(name, &block)
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
  pkg.depends_on += depends_on if depends_on.is_a?(Array)

  pkg.instance_eval(&block) if block_given?
  pkg.rake unless pkg.rake_tasks_declared?

  ["#{pkg}:configure", "#{pkg}:force:configure"].map { |t| Rake.application.lookup(t) }.each do |task|
    # "configure" depends on "get" for all packages.
    task.enhance pkg.depends_on
  end
end

def system_is_64_bit?
  system("sysctl hw.cpu64bit_capable > /dev/null 2>&1")
end

def x86_64?
  RUBY_PLATFORM =~ /x86_64/i
end

def mac?
  RUBY_PLATFORM =~ /darwin/i
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
  require t
end
