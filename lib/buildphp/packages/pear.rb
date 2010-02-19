package :pear => :xml do |pear|
  pear.configure :php do |c|
    c << "--with-pear=#{FACTORY.php.prefix}/share/pear"
  end

  pear.rake do
    Rake.application.in_namespace(pear.to_sym) do |ns|
      ns.tasks.each { |t| t.clear }
    end
    Rake.application[pear.to_sym].clear.enhance do
      abort "xml must be an included php module to install #{pear}" if FACTORY.php.depends_on.index('xml') == nil
    end
  end
end
