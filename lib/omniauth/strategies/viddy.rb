require 'oauth2'

module OmniAuth
  module Strategies
    class Viddy
      include OmniAuth::Strategy

      attr_accessor :access_token

      args [:apikey]

      option :apikey

      option :name, 'viddy'

      option :client_options, {
        site:           'https://api.viddy.com',
        authorize_url:  'https://viddy.com/oauth/authenticate',
      }

      def client
        ::OAuth2::Client.new(options.apikey, nil, deep_symbolize(options.client_options).merge(connection_opts: {params:{apikey: options.apikey}}))
      end

      credentials do
        {'access_token' => access_token.token}
      end

      uid { raw_info['id'] }

      info do
        {
          full_name:   raw_info['full_name'],
          username:    raw_info['username'],
          profile:     raw_info['profile'],
          thumbnail:   raw_info['thumbnail']['url'],
          profile_picture: raw_info['profile_picture']['url'],
          email:       raw_info['email']
        }
      end

      extra do
        { 
          user_info: raw_info
        }
      end

      def raw_info
        @raw_info ||= @access_token.get("/v1/users/me").parsed['users'][0]
      end

      protected

      def deep_symbolize(options)
        hash = {}
        options.each do |key, value|
          hash[key.to_sym] = value.is_a?(Hash) ? deep_symbolize(value) : value
        end
        hash
      end

      def request_phase
        redirect client.auth_code.authorize_url
      end

      def callback_phase
        error = request.params['error_reason'] || request.params['error']
        if error
          fail!(error, CallbackError.new(request.params['error'], request.params['error_description'] || request.params['error_reason'], request.params['error_uri']))
        else
          self.access_token = ::OAuth2::AccessToken.new(client, request.params['access_token'], :mode => :query)
          super
        end
      rescue ::OAuth2::Error, CallbackError => e
        fail!(:invalid_credentials, e)
      rescue ::MultiJson::DecodeError => e
        fail!(:invalid_response, e)
      rescue ::Timeout::Error, ::Errno::ETIMEDOUT, Faraday::Error::TimeoutError => e
        fail!(:timeout, e)
      rescue ::SocketError, Faraday::Error::ConnectionFailed => e
        fail!(:failed_to_connect, e)
      end

      # An error that is indicated in the OAuth 2.0 callback.
      # This could be a `redirect_uri_mismatch` or other
      class CallbackError < StandardError
        attr_accessor :error, :error_reason, :error_uri

        def initialize(error, error_reason = nil, error_uri = nil)
          self.error = error
          self.error_reason = error_reason
          self.error_uri = error_uri
        end

        def message
          [error, error_reason, error_uri].compact.join(' | ')
        end
      end

    end
  end
end

OmniAuth.config.add_camelization 'viddy', 'Viddy'