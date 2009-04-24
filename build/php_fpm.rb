class PhpFpm < BuildTaskAbstract
  @filename = 'php-5.2.8-fpm-0.5.10.diff.gz'
  @config = {
    :package => {
      :name => filename,
      :location => "http://php-fpm.anight.org/downloads/head/#{filename}",
      :md5 => '7104c76e2891612af636104e0f6d60d4',
    },
    :extract => {
      :cmd => "gzip -cd #{filename} | patch -d #{Php.dir} -p1 && echo '' > #{filename}.installed",
    },
    :php_config_flags => [
      "--enable-fpm",
    ],
  }
  class << self
    def is_installed
      File.exists?(File.join(EXTRACT_TO, "#{filename}.installed"))
    end
  end
end

namespace :php_fpm do
  task :get do
    PhpFpm.get()
  end
  
  task :install => :get
end
