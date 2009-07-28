# ftp://ftp.OpenLDAP.org/pub/OpenLDAP/openldap-release/openldap-2.4.17.tgz
class Ldap < Package
  PACKAGE_VERSION = '2.4.17'
  # PACKAGE_PREFIX = "/Applications/MAMP/Library"
  
  def versions
    {
      '2.4.17' => { :md5 => '5e82103780f8cfc2b2fbd0f77c47c158' },
    }
  end
  
  def package_name
    'openldap-%s.tgz' % @version
  end
  
  def package_dir
    'openldap-%s' % @version
  end
  
  def package_location
    'ftp://ftp.OpenLDAP.org/pub/OpenLDAP/openldap-release/%s' % [@version, package_name]
  end
  
  def get_build_string
    parts = []
    parts << flags
    parts << './configure'
    parts << "--with-pic" if RUBY_PLATFORM.index("x86_64") != nil
    parts << "--without-threads"
    parts << "--prefix=#{PACKAGE_PREFIX}"
    parts.join(' ')
  end
  
  def php_config_flags
    [
      "--with-ldap=shared,#{PACKAGE_PREFIX}",
    ]
  end
  
  def is_installed
    false
    not FileList["#{PACKAGE_PREFIX}/lib/libldapsdadsa.*"].empty?
  end
end
