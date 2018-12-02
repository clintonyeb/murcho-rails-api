require 'faker'

church = Church.create({
  name: 'pentecost church',
  location: "mpatasie",
  motto: "god is one"
})

user = User.create({
  full_name: "clinton yeboah",
	phone_number: "3132131",
	email: "clint@murch.com",
	access_level: :super_admin,
	password: "12312312",
	church_id: church.id
})

50.times do
  person = Person.create({
		church_id: church.id,
		first_name: Faker::Name.first_name,
		last_name: Faker::Name.last_name,
		photo: 'https://s3.ap-south-1.amazonaws.com/murch-app/simpson.jpg',
		phone_number: Faker::PhoneNumber.phone_number,
		email: Faker::Internet.free_email,
		membership_status: :member,
		date_joined: Time.now 
  })
end