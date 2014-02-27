# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.create({
		email: "pankaj@autumn.co",
		name: "Pankaj Sharma",
		auth_token: "some token",
		dob: "07-08-1992",
		maretial_status: "Single",
		gender: "Male"
	})

user.save

