require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Scientist < OmniAuth::Strategies::OAuth2
      option :client_options, {
        :site => 'https://app.scientist.com',
        :authorize_url => 'https://app.scientist.com/oauth/authorize',
        :token_url => 'https://app.scientist.com/oauth/token'
      }

      def request_phase
        super
      end

      def authorize_params
        super.tap do |params|
          %w[scope client_options].each do |v|
            if request.params[v]
              params[v.to_sym] = request.params[v]
            end
          end
        end
      end

      uid { raw_info['id'].to_s }

      info do
        {
          'nickname' => raw_info['login'],
          'email' => email,
          'name' => raw_info['name'],
          'image' => raw_info['avatar_url'],
        }
      end

      extra do
        {:raw_info => raw_info, :all_emails => emails}
      end

      def raw_info
        access_token.options[:mode] = :query
        @raw_info ||= access_token.get('user').parsed
      end

      def email
        raw_info['email']
      end

      def callback_url
        full_host + script_name + callback_path
      end
    end
  end
end

OmniAuth.config.add_camelization 'scientist', 'Scientist'
