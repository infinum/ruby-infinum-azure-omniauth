# frozen_string_literal: true

require 'time'

module OmniAuth
  module Strategies
    class InfinumAzure < OmniAuth::Strategies::OAuth2
      option :name, 'infinum_azure'
      option :policy, 'B2C_1A_SIGNUP_SIGNIN'
      option :scope, 'openid'

      def client # rubocop:disable Metrics/AbcSize
        options.client_options.authorize_url = File.join(azure_oauth_url, 'authorize')
        options.client_options.token_url = File.join(azure_oauth_url, 'token')
        options.client_options.jwks_url = File.join(base_azure_url, 'discovery/v2.0/keys')
        options.client_options.logout_url = File.join(azure_oauth_url, 'logout').concat(
          "?post_logout_redirect_uri=#{File.join(full_host, path_prefix, 'logout')}"
        )

        super
      end

      def azure_oauth_url
        File.join(base_azure_url, 'oauth2/v2.0')
      end

      def base_azure_url
        raise 'Tenant not provided' if options.client_options.tenant.nil?

        "https://#{options.client_options.tenant}.b2clogin.com/#{options.client_options.tenant}.onmicrosoft.com/#{options.policy}"
      end

      def other_phase
        return call_app! unless current_path == File.join(path_prefix, name.to_s, 'logout')

        redirect(client.options[:logout_url])
      end

      uid do
        jwt_payload['sub']
      end

      info do
        {
          email: jwt_payload['email'],
          name: jwt_payload['name'],
          first_name: jwt_payload['given_name'],
          last_name: jwt_payload['family_name'],
          provider_groups: jwt_payload['extension_userGroup'],
          avatar_url: jwt_payload['extension_avatarUrl'],
          deactivated_at: deactivated_at,
          employee: employee
        }
      end

      extra do
        {
          refresh_token: access_token.refresh_token,
          refresh_token_expires_in: access_token.params[:refresh_token_expires_in],
          params: access_token.params,
          raw_info: jwt_payload
        }
      end

      private

      def deactivated_at
        jwt_payload['extension_deactivated'] == false ? nil : Time.now.utc
      end

      def employee
        jwt_payload['extension_userGroup'].include?('employees')
      end

      def jwt_payload
        @jwt_payload ||= Jwt::Parser.new(access_token.token, client: client).validated_payload
      end
    end
  end
end
