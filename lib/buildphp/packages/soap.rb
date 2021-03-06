package :soap => :xml do
  configure :php do |c|
    c << "--enable-soap=shared"
  end

  rake do
    Rake.application.in_namespace(to_sym) do |ns|
      ns.tasks.each { |t| t.clear }
    end
    Rake.application[to_sym].clear.enhance do
      abort "xml must be an included php module to install #{self}" if FACTORY.php.depends_on.index('xml') == nil
    end
  end
end
