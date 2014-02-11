# http://rubygems.org/gems/net-http-persistent
# https://github.com/drbrain/net-http-persistent
require 'net/http/persistent'
require 'open-uri'
require 'cgi'

require 'pry'

=begin

http://api.clickatell.com/http/sendmsg
    ?callback=    "3"              static
    &mo=          MOB_ORIG         SMPP code, 1 means it's coming from a mobile
    &from=        SENDER           sender number
    &session_id=  AUTH_ID          fetched from the API through authentication
    &to=          DESTINATION      destination number
    &text=        BODY             the text message... and the encoding is through the CGI module?

=end

module ClickatellGW
  class API
    API_URL  = 'http://api.clickatell.com/http'
    
    API_ID   = ClickatellGW::Login.login[:api_id]
    USER     = ClickatellGW::Login.login[:user]
    PASSWORD = ClickatellGW::Login.login[:password]
    SENDER   = ClickatellGW::Login.login[:sender]

    # using nil
    #INVALID_AUTH_ID = "00000000000000000000000000000000" # 32 chars

    
    MOB_ORIG = '1' # Mobile-originated = allow reply
    

    AUTH_RESPONSE_REGEX = /\AOK:\s[a-f0-9]+\z/i
    AUTH_SUB_REGEX      = /\AOK:\s/i
    
    

    attr_reader :auth_url
    attr_reader :connection

    attr_accessor :auth_id
    

    def initialize
      @auth_url = URI.parse auth_url_str
      #@send_url = URI.parse base_send_url_str

      authenticate!
      open_connection
    end



    def send_text(number: nil, body: nil)
      return false unless (number && body && ready?)

      data = new_message_data
      data["to"]   = sanitize_destination number
      data["text"] = encode body

      sms_uri = URI.parse(base_send_url_str + build_url_query(data))
      
      response = connection.request sms_uri
      puts response

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
      @auth_url_str ||= "#{API_URL}/auth?api_id=#{API_ID}&user=#{USER}&password=#{PASSWORD}"
    end


    def base_send_url_str
      @base_send_url_str ||= "#{API_URL}/sendmsg"
    end


    # ------------------------------------------------


    def new_message_data
      @base_message_data ||= {
        "callback" => "3",
        "mo"       => MOB_ORIG,
        "from"     => SENDER
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



    def split_body(body)
      if body.length > 160
        # todo
      end
      body
    end



    def sanitize_destination(msisdn)
      msisdn.gsub(/[^0-9]/, "")
    end

  end



  class AuthenticationError < StandardError; end
  class SendError < StandardError; end
end


