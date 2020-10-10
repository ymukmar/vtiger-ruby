require 'faraday'
require 'json'

module VtigerRuby
  class Client
    attr_accessor :endpoint, :username, :accesskey, :session_id

    def initialize(endpoint: nil, username: nil, accesskey: nil)
      @endpoint = endpoint
      @username = username
      @accesskey = accesskey
    end

    def get_challenge
      challenge_params = { operation: 'getchallenge', username: username }

      response = Faraday.get(endpoint, challenge_params) do |req|
        req.headers['User-Agent'] = 'VtigerRuby'
      end

      body = JSON.parse(response.body)
      @token = body['result']['token']

      body
    end

    def login
      login_params = {
        'operation': 'login',
        'username': username,
        'accessKey': md5_token
      }

      response = Faraday.post(endpoint) do |req|
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        req.headers['User-Agent'] = 'VtigerRuby'
        req.body = login_params
      end

      body = JSON.parse(response.body)
      @session_id = body['result']['sessionName']

      body
    end

    def connect
      get_challenge
      login
    end

    def logout
      logout_params = {
        'operation': 'logout',
        'sessionName': @session_id
      }

      response = Faraday.post(endpoint) do |req|
        req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
        req.headers['User-Agent'] = 'VtigerRuby'
        req.body = logout_params
      end

      remove_instance_variable(:@token)
      remove_instance_variable(:@session_id)
      remove_instance_variable(:@md5_token)

      JSON.parse(response.body)
    end

    def account
      VtigerRuby::Account.class_config(self)
      VtigerRuby::Account
    end

    private
    def md5_token
      @md5_token ||= Digest::MD5.hexdigest(@token + accesskey)
    end
  end
end
