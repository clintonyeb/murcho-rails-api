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

10.times do
  group = Group.create({
		church_id: church.id,
		name: Faker::TvShows::Community.characters,
		description: Faker::TvShows::Community.quotes
  })
end

calendar = Calendar.create({
	church_id: church.id,
	name: church.name,
})

50.times do
	start_date = Faker::Date.between(Date.today, 30.days.from_now)
	duration = 60.minutes

	event_schema = EventSchema.create({
		title: Faker::Movies::Hobbit.character,
		description: Faker::Movies::Hobbit.quote,
		calendar_id: calendar.id,
		duration: duration,
		start_date: start_date,
		end_date: start_date + duration,
		location: Faker::Movies::Hobbit.location,
		color: EventSchema.colors.to_a.sample[1]
	})
end