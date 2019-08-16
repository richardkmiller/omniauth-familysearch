require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class FamilySearch < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://api.familysearch.org',
        :authorize_url => '/cis-web/oauth2/v3/authorization',
        :token_url => '/cis-web/oauth2/v3/token'
      }

      option :access_token_options, {
        :header_format => 'Bearer %s',
        :param_name => 'access_token'
      }

      def access_token_options
        options.access_token_options.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }
      end

      def request_phase
        super
      end

      def authorize_params
        super
      end

      uid { user_info['id'] }

      info do
        {
          :name => user_name,
          :email => user_email
        }
      end

      extra do
        { :raw_info => raw_info }
      end

      def raw_info
        api_site = options.client_options.api_site
        access_token.client.connection.url_prefix = api_site if api_site
        @raw_info ||= access_token.get('/platform/users/current',
                                       :headers => { 'Accept' => 'application/x-fs-v1+json' },
                                       :parse => :json
                                      ).parsed
      end

      def user_info
        @user_info ||= raw_info['users'] ? raw_info['users'].first : {}
      end

      def user_name
        user_info['contactName']
      end

      def user_email
        user_info['email']
      end

      protected

      def build_access_token
        # Fix added so that mobile clients can use this gem by providing access_token
        # instead of passing signed_request and setting cookies.
        if has_login?
          request_hash = JSON.parse(make_http_request.body)
          access_token = request_hash["token"]
        else
          access_token = request.params["access_token"]
        end

        if access_token
          ::OAuth2::AccessToken.from_hash(
            client,
            {"access_token" => access_token}.update(access_token_options)
          )
        else
          verifier = request.params["code"]
          callback_url_without_params = callback_url.split('?').first
          client.auth_code.get_token(verifier, {:redirect_uri => callback_url_without_params}.merge(token_params.to_hash(:symbolize_keys => true)), deep_symbolize(options.auth_token_params))
        end
      end

      def has_login?
        request.params["grant_type"] == "password"
      end

      def make_http_request
        uri = URI(options["client_options"]["site"])
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        path = options["client_options"]["token_url"]
        params = { grant_type: request.params["grant_type"],
                   username: request.params["username"],
                   password: request.params["password"],
                   client_id: options["client_id"]
        }
        http.post(path, params.to_param, {})
      end
    end
  end
end

OmniAuth.config.add_camelization 'familysearch', 'FamilySearch'
