require "password_encryptor"

RSpec.describe PasswordEncryptor do
  describe ".encrypt" do
    let(:password) { "hello world" }
    let(:salt) { "123456788" }

    it "generates an encrypted password based on the password and salt" do
      result = described_class.encrypt password, salt

      expect(result).to_not be_nil
      expect(result).to_not eq password
    end

    it "generates different results if the password and salt are the same" do
      result1 = described_class.encrypt password, salt
      result2 = described_class.encrypt password, salt

      expect(result1).to_not eq result2
    end
  end
end
