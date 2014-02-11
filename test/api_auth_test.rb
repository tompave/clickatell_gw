require 'test_helper'

class APIAuthTest < Minitest::Test

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


  def test_status_after_initialize
    assert_instance_of ClickatellGW::API, @api
    assert_equal "1111", @api.instance_variable_get(:@app_id)
    assert_equal "hello", @api.instance_variable_get(:@user)
    assert_equal "password", @api.instance_variable_get(:@password)
    assert_equal "131313132", @api.instance_variable_get(:@sender)
  end

  def test_authenticate_ok
    assert_equal @api.auth_id, "00000000000000000000000000000000"
    assert_equal @api.authenticate!, "00000000000000000000000000000000"
  end

  def test_authenticate_failure
    # stub_request(:get, "http://api.clickatell.com/http/auth?api_id=1111&password=password&user=hello")
    #         .to_return(status: 200, body: "OK: 00000000000000000000000000000000")

    # assert_equal @api.auth_id, "00000000000000000000000000000000"
    # assert_equal @api.authenticate!, "00000000000000000000000000000000"
  end

end



# class APIAuthTestSuccess < APIAuthTest

# end


# class APIAuthTestFailure < APIAuthTest

# end