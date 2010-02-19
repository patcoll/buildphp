module Buildphp
  class PackageFactory
    def packages
      @packages ||= Hash.new
    end

    def packages=(hash)
      @packages = hash
    end

    def [](name)
      name = name.to_s.to_sym
      if packages[name].nil?
        Dir[File.expand_path(File.join(File.dirname(__FILE__), "packages/#{name}.rb"))].each do |t|
          require t
        end
        packages[name] = Package.new(name)
      end
      packages[name]
    end

    def []=(name, package)
      packages[name.to_s] = package
    end

    def to_a
      packages.keys
    end

    def to_hash
      packages
    end

    def method_missing(symbol, *args)
      self[symbol.to_s]
    end
  end
end