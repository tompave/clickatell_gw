require 'clickatell_gw'

#require 'minitest/unit'
require 'minitest/autorun'
#require 'minitest/pride'

require 'webmock/minitest'

# http://blakewilliams.me/blog/6-developing-gems-with-tdd-and-minitest-pt-1

WebMock.disable_net_connect!(allow_localhost: true,
                   net_http_connect_on_start: true)


#puts "#{__FILE__} loaded"


