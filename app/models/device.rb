class Device < ApplicationRecord
  belongs_to :player

  validates :token, presence: true,
                    uniqueness: { message: "has already been registered" }
end
