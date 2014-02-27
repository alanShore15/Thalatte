class Company < ActiveRecord::Base
	has_many :posts, class_name: "WorkFor"
	has_many :employees, class_name: "User", through: :posts
end
