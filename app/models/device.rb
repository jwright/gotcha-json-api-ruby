class Device < ApplicationRecord
  belongs_to :player

  scope :for, ->(player) { where(player_id: player) }

  validates :token, presence: true,
                    uniqueness: { scope: :player_id,
                                  message: "has already been registered" }
end
