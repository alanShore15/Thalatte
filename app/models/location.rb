class Location < ActiveRecord::Base
	belongs_to :user

	validates :latitude, :longitude, presence: true
end
