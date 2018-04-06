class Arena < ApplicationRecord
  geocoded_by :address

  has_many :player_arenas, dependent: :destroy
  has_many :players, through: :player_arenas

  after_validation :geocode, if: :address_changed?

  def address
    [street_address1, street_address2, city, state, zip_code]
      .select { |component| !component.blank? }
      .join(", ")
  end

  def playable_by?(player)
    players.include?(player)
  end

  private

  def address_changed?
    latitude.nil? &&
    longitude.nil? &&
    changes.keys.any? do |attribute|
      ["street_address1",
       "street_address2",
       "city",
       "state",
       "zip_code"].include?(attribute)
    end
  end
end
