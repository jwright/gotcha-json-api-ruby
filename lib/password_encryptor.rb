require "bcrypt"

class PasswordEncryptor
  def self.encrypt(password, salt)
    ::BCrypt::Password.create([password, salt].join, cost: 10)
  end

  def self.matches?(password, crypted_password, salt)
    return false if crypted_password.nil?
    hash = ::BCrypt::Password.new(crypted_password)
    return false if hash.nil? || hash.empty?
    hash == [password, salt].join
  end
end
