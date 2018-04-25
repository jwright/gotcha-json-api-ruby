require "securerandom"

class TokenGenerator
  def self.generate
    SecureRandom.base64(15).tr("+/=lIO0", "pqrsxyz")
  end

  def self.generate_code(number_of_digits)
    rand(10 ** number_of_digits).to_s
  end
end
