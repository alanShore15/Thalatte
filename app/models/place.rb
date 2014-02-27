class Place < ActiveRecord::Base
	has_many :visits, class_name: "HasVisited"
	has_many :users, through: :visits
end
