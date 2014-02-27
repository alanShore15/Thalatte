class Interest < ActiveRecord::Base
	has_many :related_users, class_name: "InterestedIn"
	has_many :interested_users, class_name: "User", through: :related_users
end
