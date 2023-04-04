# frozen_string_literal: true

module OmniAuth
  module Strategies
    class InfinumAzure < OmniAuth::Strategies::OAuth2
      option :name, 'infinum_azure'
      option :policy, 'B2C_1A_SIGNUP_SIGNIN'
      option :scope, 'openid'

      def client
        options.client_options.authorize_url = File.join(base_azure_url, 'authorize')
        options.client_options.token_url = File.join(base_azure_url, 'token')

        super
      end

      def base_azure_url
        raise 'Tenant not provided' if tenant.nil?

        "https://#{tenant}.b2clogin.com/#{tenant}.onmicrosoft.com/#{options.policy}/oauth2/v2.0"
      end

      def tenant
        options.client_options.tenant
      end

      def other_phase
        return call_app! unless current_path == File.join(path_prefix, name.to_s, 'logout')

        redirect(logout_url)
      end

      def logout_url
        File.join(base_azure_url, 'logout') + "?post_logout_redirect_uri=#{File.join(full_host, path_prefix, 'logout')}"
      end

      uid do
        raw_info['sub']
      end

      info do
        {
          email: raw_info['email'],
          name: raw_info['name'],
          first_name: raw_info['given_name'],
          last_name: raw_info['family_name']
        }
      end

      def extra
        {
          refresh_token: access_token.refresh_token,
          refresh_token_expires_in: access_token.params[:refresh_token_expires_in],
          params: access_token.params,
          raw_info: raw_info
        }
      end

      def raw_info
        @raw_info ||= ::JWT.decode(access_token.token, nil, false).first
      end
    end
  end
end
