# frozen_string_literal: true

module OmniAuth
  module Jwt
    class Parser
      DEFAULT_ALG = 'RS256'
      attr_reader :token, :client

      def initialize(token, client:)
        @token = token
        @client = client
      end

      def validated_payload
        ::JWT.decode(token, nil, true, jwks: jwks, algorithms: algorithms).first
      end

      private

      def jwks
        @jwks ||= JWT::JWK::Set.new(
          jwks_response['keys'].map do |key|
            key.merge(alg: jwt_headers['alg'] || DEFAULT_ALG)
          end
        )
      end

      def jwks_response
        JSON.parse(
          client.request(:get, client.options[:jwks_url]).body
        )
      end

      def jwt_headers
        decoded_jwt.last
      end

      def decoded_jwt
        @decoded_jwt ||= ::JWT.decode(token, nil, false)
      end

      def algorithms
        jwks.map { |key| key[:alg] }.compact.uniq
      end
    end
  end
end
