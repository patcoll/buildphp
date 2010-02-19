package :soap => :xml do |soap|
  soap.configure :php do |c|
    c << "--enable-soap=shared"
  end

  soap.rake do
    Rake.application.in_namespace(soap.to_sym) do |ns|
      ns.tasks.each { |t| t.clear }
    end
    Rake.application[soap.to_sym].clear.enhance do
      abort "xml must be an included php module to install #{soap}" if FACTORY.php.depends_on.index('xml') == nil
    end
  end
end
