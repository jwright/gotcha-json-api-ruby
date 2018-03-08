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

  describe ".matches?" do
    let(:password) { "hello world" }
    let(:salt) { "123456788" }
    let(:crypted_password) { described_class.encrypt password, salt }

    it "returns true if password matches encrypted password" do
      result = described_class.matches? password, crypted_password, salt

      expect(result).to be_truthy
    end

    it "returns false if password doesn't match encrypted password" do
      result = described_class.matches? "blah", crypted_password, salt

      expect(result).to be_falsey
    end

    it "returns false if password is nil" do
      result = described_class.matches? nil, crypted_password, salt

      expect(result).to be_falsey
    end

    it "returns encrypted password  if password is nil" do
      result = described_class.matches? password, nil, salt

      expect(result).to be_falsey
    end
  end
end
