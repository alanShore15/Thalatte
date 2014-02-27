json.array!(@users) do |user|
  json.extract! user, :email, :name, :auth_token, :dob, :maretial_status, :gender, :fb_id, :linkedin_id
  json.url user_url(user, format: :json)
end