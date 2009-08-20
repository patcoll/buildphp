module Buildphp
  TMP_DIR = ENV['BUILDPHP_TMP_DIR'] || File.join($base_dir, 'tmp')
  EXTRACT_TO = ENV['BUILDPHP_EXTRACT_TO'] || File.join($base_dir, 'src')
  INSTALL_TO = ENV['BUILDPHP_INSTALL_TO'] || File.join($base_dir, 'local')
  MAMP_MODE = ENV['MAMP_MODE'] || false # TODO: implement MAMP compatibility mode that would link the PHP build against libraries included with MAMP
end
