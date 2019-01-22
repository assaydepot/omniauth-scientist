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

      uid { user_attribute('id') }

      info do
        {
          'uid' => uid,
          'email' => email,
          'name' => "#{user_attribute('first_name')} #{user_attribute('last_name')}",
          'first_name' => user_attribute('first_name'),
          'last_name' => user_attribute('last_name'),
          'title' => user_attribute('title'),
          'company' => user_attribute('company'),
          'site' => user_attribute('site')
        }
      end

      extra do
        { raw_info: raw_info }
      end

      def raw_info
        access_token.options[:mode] = :header
        @raw_info ||= { 'user' => access_token['user'] }
      end

      def email
        user_attribute('email')
      end

      def callback_url
        full_host + script_name + callback_path
      end

      protected

      def user_attribute(attribute)
        raw_info['user'][attribute] if raw_info['user']
      end
    end
  end
end
