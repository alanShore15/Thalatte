class Language < ActiveRecord::Base
	has_many :users_speaking, class_name: "Speak"
	has_many :Speakers, class_name: "User", through: :users_speaking
end
