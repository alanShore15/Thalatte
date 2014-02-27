class StudyAt < ActiveRecord::Base
	belongs_to :user
	belongs_to :institute
end
