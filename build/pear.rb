class Pear < Package
  PACKAGE_VERSION = '5.3.0'
  
  def package_depends_on
    [
      'xml',
    ]
  end
  
  def php_config_flags
    [
      "--with-pear=#{Php::PACKAGE_PREFIX}/share/pear",
    ]
  end
  
  def is_installed
    FACTORY.get('xml').is_installed
  end
end
