require "bcrypt"

class PasswordEncryptor
  def self.encrypt(password, salt)
    ::BCrypt::Password.create([password, salt].join, cost: 10)
  end
end
