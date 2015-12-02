
module Logger
  
  ## If Log Directory does not exist, create it.
  def self.create_dir
    Dir.mkdir 'logs' unless Dir.exists? 'logs'
  end

end
