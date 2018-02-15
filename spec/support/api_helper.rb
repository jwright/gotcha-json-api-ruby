module APIHelper
  def json_response
    JSON.parse(response.body).deep_symbolize_keys
  end

  def valid_authed_headers(user=player)
    valid_headers.merge("Authorization": "Bearer: #{user.api_key}")
  end

  def valid_headers
    {
      "Accept": JSONAPI::MEDIA_TYPE,
      "Content-type": JSONAPI::MEDIA_TYPE
    }
  end
end
