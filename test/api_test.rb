require 'test_helper'

class APITest < Minitest::Test

  def setup
    stub_request(:get, "http://api.clickatell.com/http/auth?api_id=1111&password=password&user=hello")
            .to_return(status: 200, body: "OK: 00000000000000000000000000000000")


    ClickatellGW.setup do |config|
      config.api_id = "1111"
      config.user = "hello"
      config.password = "password"
      config.sender = "131313132"
    end

    @api = ClickatellGW::API.new
  end



  # def test_
  # end

  # def test_
  # end

  # def test_
  # end

  # def test_
  # end

  # def test_
  # end

  # def test_
  # end

  # def test_
  # end

  # def test_
  # end
end