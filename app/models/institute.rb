class Institute < ActiveRecord::Base
	has_many :degree_holders, class_name: "StudyAt"
	has_many :students, class_name: "User", through: :degree_holders, source: :user
end
