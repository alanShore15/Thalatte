json.array!(@connections) do |connection|
  json.extract! connection, :user_id, :connection_id, :connection_type
  json.url connection_url(connection, format: :json)
end