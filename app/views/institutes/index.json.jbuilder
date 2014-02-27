json.array!(@institutes) do |institute|
  json.extract! institute, :institute_name, :city, :country
  json.url institute_url(institute, format: :json)
end