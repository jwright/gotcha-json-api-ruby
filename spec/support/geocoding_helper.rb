module GeocodingHelper
  def stub_geocoding(latitude, longitude)
    response = {
      results: [{
        geometry: {
          location: {
            lat: latitude,
            lng: longitude
          }
        }
      }],
      status: "OK"
    }

    WebMock.stub_request(:get,
      "http://maps.googleapis.com/maps/api/geocode/json")
      .with(query: hash_including({}))
      .to_return(status: 200, body: response.to_json, headers: {})
  end
end
