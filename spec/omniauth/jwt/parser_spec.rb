# frozen_string_literal: true

RSpec.describe OmniAuth::Jwt::Parser do
  let(:client_mock) { instance_double(OAuth2::Client) }
  let(:jwks_response_mock) do
    instance_double(OAuth2::Response, body: File.read('spec/support/files/jwks/mocked_response.json'))
  end

  before do
    allow(client_mock).to receive(:request).and_return(jwks_response_mock)
    allow(client_mock).to receive(:options).and_return({ jwks_url: 'jwks_url' })
    allow(JWT).to receive(:decode).and_call_original
  end

  describe '#validated_payload' do
    subject(:payload) { described_class.new(token, client: client_mock).validated_payload }

    context 'when token is valid' do
      let(:token) { File.read('spec/support/files/jwt/valid') }

      it 'returns a hash containing relevant properties' do
        expect(payload.keys).to include(
          'sub', 'email', 'name', 'given_name', 'family_name',
          'extension_userGroup', 'extension_avatarUrl', 'extension_deactivated', 'extension_userGroup'
        )
      end

      it 'attaches the alg property to the JWKs' do
        jwks = JWT::JWK::Set.new(JSON.parse(File.read('spec/support/files/jwks/final_keys.json')))

        payload

        expect(JWT).to have_received(:decode).with(token, nil, false).once
        expect(JWT).to have_received(:decode).with(token, nil, true, jwks: jwks, algorithms: ['RS512']).once
      end
    end

    context 'when token is invalid' do
      let(:token) { File.read('spec/support/files/jwt/invalid') }

      it 'raises JWT::VerificationError' do
        expect { payload }.to raise_error(JWT::VerificationError)
      end
    end
  end
end
