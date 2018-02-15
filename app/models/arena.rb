class Arena < ApplicationRecord
  geocoded_by :address

  def address
    [street_address1, street_address2, city, state, zip_code]
      .select { |component| !component.blank? }
      .join(", ")
  end
end
