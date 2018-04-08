require "password_encryptor"
require "token_generator"

class Player < ApplicationRecord
  attr_accessor :password

  has_many :player_arenas, dependent: :destroy
  has_many :arenas, through: :player_arenas

  mount_base64_uploader :avatar, AvatarUploader

  scope :already_matched_with, ->(player, arena) do
    players_in_common_matches = Match.in(arena).where(seeker_id: player)
      .or(Match.in(arena).where(opponent_id: player))
      .pluck(:seeker_id, :opponent_id).flatten
    where(id: players_in_common_matches).where.not(id: player)
  end

  scope :in, ->(arena) do
    joins(:player_arenas).where(player_arenas: { arena_id: arena })
  end

  scope :not_already_matched_with, ->(player, arena) do
    already_matched_with_players = already_matched_with(player, arena).pluck(:id)
    where.not(id: already_matched_with_players).where.not(id: player)
  end

  scope :unmatched, -> do
    players_in_open_matches = Match.open.pluck(:seeker_id, :opponent_id).flatten
    where.not(id: players_in_open_matches)
  end

  before_validation :encrypt_password, if: proc { |p| p.password }
  after_save :clear_virtual_password

  validates :email_address, presence: true,
                            format: { with: Validations::Email },
                            uniqueness: { case_sensitive: false,
                                          message: "has already been registered" }
  validates :name, presence: true
  validates :password, presence: true,
                       if: proc { |p| p.new_record? || p.crypted_password_changed? }

  def self.authenticate(email_address, password)
    player = with_email_address(email_address)
    return nil unless player
    player if PasswordEncryptor.matches?(password, player.crypted_password, player.salt)
  end

  def self.with_api_key(api_key)
    where(api_key: api_key).first unless api_key.blank?
  end

  def self.with_email_address(email_address)
    where("LOWER(email_address) = :email_address",
          email_address: (email_address || "").downcase).first
  end

  def generate_api_key!(force=true)
    return false if !force && !api_key.blank?
    update_attributes(api_key: TokenGenerator.generate)
  end

  def matched_in?(arena)
    Match.in(arena).open.where(seeker_id: id)
      .or(Match.in(arena).open.where(opponent_id: id))
      .exists?
  end

  private

  def clear_virtual_password
    self.password = nil
  end

  def encrypt_password
    self.salt = TokenGenerator.generate
    self.crypted_password = PasswordEncryptor.encrypt(self.password, self.salt)
  end
end
