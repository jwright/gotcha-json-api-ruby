require "securerandom"

class TokenGenerator
  def self.generate
    SecureRandom.base64(15).tr("+/=lIO0", "pqrsxyz")
  end
end
