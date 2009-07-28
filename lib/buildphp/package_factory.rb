class PackageFactory
  attr_reader :packages
  def initialize
    @packages = []
  end
  def add(package)
    return nil if not package.is_a?(Package)
    @packages.push(package)
  end
  def get(class_name)
    @packages.detect do |package|
      package.class.to_s == class_name.to_s || Inflect.underscore(package.class.to_s) == class_name.to_s
    end
  end
end