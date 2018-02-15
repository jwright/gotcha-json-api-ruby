class Arena < ApplicationRecord
  geocoded_by :address

  after_validation :geocode, if: :address_changed?

  def address
    [street_address1, street_address2, city, state, zip_code]
      .select { |component| !component.blank? }
      .join(", ")
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
