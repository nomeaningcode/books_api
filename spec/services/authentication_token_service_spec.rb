require 'rails_helper'

describe AuthenticationTokenService do
  describe '.call' do
    it 'returns authentication token' do
      token = described_class.call
      decode_token = JWT.decode token, described_class::HMAC_SECRET, true, { algorithm: described_class::ALGORITHM_TYPE }

      expect(decode_token).to eq(
        [
          {'test' => 'blah'},
          {'alg' => 'HS256'}
        ]
      )
    end
  end
end