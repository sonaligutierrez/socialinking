def working_url?(url_str)
  begin
    Net::HTTP.get_response(URI.parse(url_str)).is_a?(Net::HTTPSuccess)
  rescue
    false
  end
end
