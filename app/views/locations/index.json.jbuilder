json.array!(@locations) do |location|
  json.extract! location, :user_id, :longitude, :latitude, :name
  json.url location_url(location, format: :json)
end