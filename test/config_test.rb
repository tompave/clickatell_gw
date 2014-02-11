require 'test_helper'

class ConfigTest < Minitest::Test

  def setup
    ClickatellGW.setup do |config|
      config.api_id = "1111"
      config.user = "hello"
      config.password = "password"
      config.sender = "131313132"
    end
  end


  def test_config_module
    assert_equal ClickatellGW::Config.api_id, "1111"
    assert_equal ClickatellGW::Config.user, "hello"
    assert_equal ClickatellGW::Config.password, "password"
    assert_equal ClickatellGW::Config.sender, "131313132"
  end


  def test_api_object
    stub_request(:get, "http://api.clickatell.com/http/auth?api_id=1111&password=password&user=hello")
            .to_return(status: 200, body: "OK: 00000000000000000000000000000000")

    @api = ClickatellGW::API.new

    assert_equal "1111", @api.instance_variable_get(:@app_id)
    assert_equal "hello", @api.instance_variable_get(:@user)
    assert_equal "password", @api.instance_variable_get(:@password)
    assert_equal "131313132", @api.instance_variable_get(:@sender)
  end
end
