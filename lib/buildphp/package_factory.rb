module Buildphp
  class PackageFactory
    attr_reader :packages
    attr_accessor :mamp_mode
    def initialize
      @packages = []
      @mamp_mode = false
      yield self if block_given?
    end
    def add(package)
      return nil if not package.is_a?(Buildphp::Package)
      @packages.push(package)
    end
    def get(class_name)
      @packages.find do |package|
        package.to_s == class_name.to_s || package.to_s == Inflect.underscore(class_name.to_s)
      end
    end
  end
end