module Buildphp
  class PackageFactory
    def packages
      @packages ||= Hash.new
    end

    def packages=(hash)
      @packages = hash
    end

    def [](name)
      packages[name.to_s] || nil
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
      Dir[File.expand_path(File.join(File.dirname(__FILE__), "packages/#{symbol}.rb"))].each do |t|
        require t
      end
      self[symbol.to_s]
    end
  end
end