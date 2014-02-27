json.array!(@interests) do |interest|
  json.extract! interest, :interest_name
  json.url interest_url(interest, format: :json)
end