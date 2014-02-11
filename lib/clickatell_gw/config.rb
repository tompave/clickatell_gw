module ClickatellGW
  
  def self.setup
    yield ClickatellGW::Config
  end

  module Config
    class << self
      attr_accessor :api_id
      attr_accessor :user
      attr_accessor :password
      attr_accessor :sender
    end
  end
end



=begin

ClickatellGW.setup do |config|
  config.api_id = ""
  config.user = ""
  config.password = ""
  config.sender = ""
end

=end
