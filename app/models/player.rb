require "password_encryptor"
require "token_generator"

class Player < ApplicationRecord
  attr_accessor :password

  before_validation :encrypt_password
  after_save :clear_virtual_password

  private

  def clear_virtual_password
    self.password = nil
  end

  def encrypt_password
    self.salt = TokenGenerator.generate
    self.crypted_password = PasswordEncryptor.encrypt(self.password, self.salt)
  end
end
