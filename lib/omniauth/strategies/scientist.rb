require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Scientist < OmniAuth::Strategies::OAuth2
      option :client_options, {
        site: 'https://app.scientist.com',
        authorize_url: 'https://app.scientist.com/oauth/authorize',
        token_url: 'https://app.scientist.com/oauth/token'
      }

      def request_phase
        super
      end

      def authorize_params
        super.tap do |params|
          %w[client_options].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end
        end
      end

      uid {
        raw_info['id'].to_s
      }

      info do
        {
          'provider' => 'scientist',
          'uid' => uid,
          'email' => email,
          'name' => "#{raw_info['first_name']} #{raw_info['last_name']}",
          'first_name' => raw_info['first_name'],
          'last_name' => raw_info['last_name'],
          'title' => raw_info['title'],
          'company' => raw_info['company'],
          'site' => raw_info['site']
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        access_token.options[:mode] = :header
        @raw_info ||= access_token["user"]
      end

      def email
        raw_info['email']
      end

      def callback_url
        full_host + callback_path
      end
    end
  end
end
