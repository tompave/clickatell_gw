#clickatell_gw

Wrapper for the Clickatell API

##Config

```ruby

ClickatellGW.setup do |config|
  config.api_id = ""
  config.user = ""
  config.password = ""
  config.sender = ""
end

```

##Use

```ruby
require 'clickatell_gw'

api = Clickatell::API.new
api.send_text body: "Hello World!", number: "44123456789"
# => sent message id
```