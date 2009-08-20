module Buildphp
  class PackageFactory
    @@mamp_packages = []
    attr_reader :packages
    attr_accessor :mamp_mode
    def initialize
      @packages = []
      @mamp_mode = false
      yield self if block_given?
    end
    def add(package)
      return nil if not package.is_a?(Buildphp::Package)
      # TODO: the only way to include real support for building against libraries included with MAMP is to copy development headers for all packages into /Applications/MAMP/Library/include
      package.prefix = "/Applications/MAMP/Library" if Buildphp::MAMP_MODE and @@mamp_packages.find { |p| p == package.to_s }
      @packages.push(package)
    end
    def get(class_name)
      @packages.find do |package|
        package.to_s == class_name.to_s || package.to_s == Inflect.underscore(class_name.to_s)
      end
    end
  end
end