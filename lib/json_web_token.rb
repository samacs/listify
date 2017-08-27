require 'jwt'

# Manage JSON Web Tokens.
class JsonWebToken
  class << self
    # Encodes and signs JWT Payload with expiration
    def encode(payload)
      payload.reverse_merge!(meta)
      JWT.encode(payload, Rails.application.secrets.secret_key_base)
    end

    def decode(token)
      JWT.decode(token, Rails.application.secrets.secret_key_base)
    end

    def valid_payload(payload)
      payload.deep_symbolize_keys!
      if expired?(payload) ||
         payload[:iss] != meta[:iss] ||
         payload[:aud] != meta[:aud]
        false
      else
        true
      end
    end

    private

    def meta
      {
        exp: 7.days.from_now.to_i,
        iss: 'listify',
        aud: 'client'
      }
    end

    def expired?(payload)
      Time.at(payload[:exp]) < Time.now
    end
  end
end
