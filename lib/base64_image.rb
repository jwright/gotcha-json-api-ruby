class Base64Image
  REGEXP = /\Adata:([-\w]+\/[-\w\+\.]+)?;base64,(.*)/m

  def self.decode(encoded, filename="")
    if data = encoded.match(REGEXP)
      content_type = data[1]
      mime_type = Mime::Type.lookup content_type
      [StringIO.new(Base64.strict_decode64(data[2] || "")),
       "#{filename}.#{mime_type.symbol}",
       content_type]
    end
  end

  def self.encode(file)
    mime_type = Mime::Type.lookup_by_extension(file.extname.gsub(".", ""))
    prefix = "data:#{mime_type};base64,"
    "#{prefix}#{Base64.strict_encode64(file.read)}"
  end
end
