module Buildphp
  TMP_DIR = ENV['TMP_DIR'] || $TMP_DIR || File.join($base_dir, 'tmp')
  EXTRACT_TO = ENV['EXTRACT_TO'] || $EXTRACT_TO || File.join($base_dir, 'src')
  INSTALL_TO = ENV['INSTALL_TO'] || $INSTALL_TO || File.join($base_dir, 'local')
  MAMP_MODE = ENV['MAMP_MODE'] || $MAMP_MODE || false # TODO: implement MAMP compatibility mode that would link the PHP build against libraries included with MAMP
end
