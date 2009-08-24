module Buildphp
  class PackageFactory
    include Enumerable
    
    attr_reader :packages
    
    def initialize
      @packages = []
      yield self if block_given?
    end
    
    def [](pkg_name)
      get(pkg_name)
    end
    
    def each
      @packages.each { |i| yield i }
    end
    
    def add(package)
      raise "Not a package." if not package.is_a?(Buildphp::Package)
      # TODO: the only way to include real support for building against libraries included with MAMP is to copy development headers for all packages into /Applications/MAMP/Library/include
      # package.prefix = "/Applications/MAMP/Library" if Buildphp::MAMP_MODE and @@mamp_packages.find { |p| p == package.to_s }
      @packages.push(package)
    end
    
    def get(pkg_name)
      pkg_name = pkg_name.to_s
      @packages.find do |package|
        package = package.to_s
        package == pkg_name || package == Inflect.underscore(pkg_name)
      end
    end
  end
end