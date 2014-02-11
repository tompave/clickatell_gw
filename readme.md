#clickatell_gw

Wrapper for the Clickatell API

## Installation

Add this line to your application's Gemfile:

    gem 'clickatell_gw'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install clickatell_gw


##Configuration

Anywhere before creating an `ClickatellGW::API` object. In Rails, this can go in an initializer.

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

api = ClickatellGW::API.new
api.send_text body: "Hello World!", number: "44123456789"
# => sent message id
```

##Caveats

The Cliclatell API can take up to 1-2 seconds to return a response.  
If this is an issue (e.g. during an HTTP request), consider using a background worker.

##ToDo

* Send messages on a secondary thread.
* Add logging



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
