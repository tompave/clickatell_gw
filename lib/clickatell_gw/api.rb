# http://rubygems.org/gems/net-http-persistent
# https://github.com/drbrain/net-http-persistent
require 'net/http/persistent'
require 'open-uri'
require 'cgi'


=begin

http://api.clickatell.com/http/sendmsg
    ?callback=    "3"              static
    &mo=          MOB_ORIG         SMPP code, 1 means it's coming from a mobile
    &from=        @sender          ender number
    &session_id=  AUTH_ID          fetched from the API through authentication
    &to=          DESTINATION      destination number
    &text=        BODY             the text message... and the encoding is through the CGI module?

=end

module ClickatellGW
  class API
    API_URL  = 'http://api.clickatell.com/http'
    
    # using nil
    #INVALID_AUTH_ID = "00000000000000000000000000000000" # 32 chars
    
    MOB_ORIG = '1' # Mobile-originated = allow reply
    
    AUTH_RESPONSE_REGEX = /\AOK:\s[a-f0-9]+\z/i
    AUTH_SUB_REGEX      = /\AOK:\s/i
    
    CONCAT_SMS_LENGTH_LIMIT = 153
    

    attr_reader :auth_url
    attr_reader :connection

    attr_accessor :auth_id
    

    def initialize
      load_config

      @auth_url = URI.parse auth_url_str
      #@send_url = URI.parse base_send_url_str

      authenticate!
      open_connection
    end


    def load_config
      @app_id   = ClickatellGW::Config.api_id
      @user     = ClickatellGW::Config.user
      @password = ClickatellGW::Config.password
      @sender   = ClickatellGW::Config.sender
    end


    def send_text(number: nil, body: nil)
      return false unless (number && body && ready?)

      data = new_message_data
      data["to"]   = sanitize_destination number
      data["text"] = encode body

      query = build_url_query(data)

      if sms_uri = URI.parse(base_send_url_str + query)
        response = connection.request sms_uri
        puts response.body
      else
        false
      end

    rescue => error
      puts error
    end


    def build_url_query(data)
      query = ""
      equal = "="
      sep = "&"

      data.each_pair do |key, value|
        query << sep
        query << key
        query << equal
        query << value
      end

      query << parts_count_param_str(data["text"])

      # the first one
      query.sub!("&", "?")

      return query
    end



    # ------------------------------------------------
    # API Authentication

    def authenticate!
      response = open(self.auth_url).read

      if AUTH_RESPONSE_REGEX =~ response
        self.auth_id = response.sub(AUTH_SUB_REGEX, "")
      else
        self.auth_id = nil
        return nil
      end
    rescue => error
      self.auth_id = nil
      return nil
    end


    def ready?
      !!self.auth_id
    end




    # ------------------------------------------------
    # network

    def open_connection
      @connection = Net::HTTP::Persistent.new "custom_name"
    end

    def close_connection
      @connection.shutdown if @connection
    rescue
      nil
    end


    def send_sms_http_post(arg)

    end


    # ------------------------------------------------
    # URL generation

    def auth_url_str
      @auth_url_str ||= "#{API_URL}/auth?api_id=#{@app_id}&user=#{@user}&password=#{@password}"
    end


    def base_send_url_str
      @base_send_url_str ||= "#{API_URL}/sendmsg"
    end


    # ------------------------------------------------


    def new_message_data
      @base_message_data ||= {
        "callback" => "3",
        "mo"       => MOB_ORIG,
        "from"     => @sender
      }

      data = @base_message_data.dup
      data["session_id"] = self.auth_id

      return data
    end



    # ------------------------------------------------
    # Utilities

    def encode(body)
      CGI.escape body
    end



    def body_parts(body)
      if body.length > 160
        q, r = body.length.divmod CONCAT_SMS_LENGTH_LIMIT
        q += 1 if r > 0
        return q
      else
        return 1
      end
    end


    def parts_count_param_str(body)
      parts = body_parts body
      if parts > 1
        "&concat=#{parts}"
      else
        ""
      end
    end



    def sanitize_destination(msisdn)
      msisdn.gsub(/[^0-9]/, "")
    end

  end



  class AuthenticationError < StandardError; end
  class SendError < StandardError; end
end


