class User < ActiveRecord::Base

	has_many :locations

	has_many :degrees, class_name: "StudyAt"
	has_many :institutes, through: :degrees

	has_many :jobs, class_name: "WorkFor"
	has_many :companies, through: :jobs

	has_many :visits, class_name: "HasVisited"
	has_many :places_visited, class_name: "Place", through: :visits, source: :place

	has_many :interested_into, class_name: "InterestedIn"
	has_many :interests, through: :interested_into

	has_many :connections
	has_many :connected_users, class_name: "User", through: :connections

	has_many :statuses
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	
	validates :name, presence: true
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true

	before_save do
		generate_token :auth_token
	end

	def generate_token(column)
      begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
    end

    def status
    	statuses.last.nil? ? "#{name} hasn't shared anything yet." : statuses.last.status
    end

    def profile_pic
    	self.profile_pic_url.nil? ? "http://graph.facebook.com/#{self.fb_id}/picture?width=70&height=70" : self.profile_pic_url
    end

	def self.nearby location, current_user_id
		lat = location[:latitude]
		long = location[:longitude]
		nearby_locations = Location.where("abs(longitude - ?) < 0.01 AND abs(latitude - ?) < 0.01 ", long, lat)
		nearby_users = User.where("id IN (?) ", nearby_locations.pluck(:user_id)).distinct
		return nearby_users, nearby_locations
	end

end
