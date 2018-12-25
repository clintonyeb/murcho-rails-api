require 'faker'

church = Church.create!({
  name: 'The Church of Pentecost Ghana',
	location: "Mpatasie Local",
	photo: 'https://s3.ap-south-1.amazonaws.com/murch-assets/pentecost_logo.jpg',
  motto: Faker::Movies::Hobbit.quote
})

user = User.create!({
  full_name: "clinton yeboah",
	phone_number: "3132131",
	email: "admin@murcho.com",
	access_level: :super_admin,
	password: "12312312",
	church_id: church.id
})

50.times do
  person = Person.create!({
		church_id: church.id,
		first_name: Faker::Name.first_name,
		last_name: Faker::Name.last_name,
		photo: 'https://s3.ap-south-1.amazonaws.com/murch-app/simpson.jpg',
		thumbnail: 'https://s3.ap-south-1.amazonaws.com/murch-app/simpson.jpg',
		phone_number: Faker::PhoneNumber.unique.phone_number, # unique
		email: Faker::Internet.unique.free_email, # unique
		membership_status: :member,
		date_joined: Time.now 
  })
end

50.times do
  group = Group.create!({
		church_id: church.id,
		name: Faker::Coffee.unique.blend_name, # unique
		description: Faker::TvShows::Community.quotes
  })
end

50.times do
	start_date = Faker::Date.between(Date.today, 30.days.from_now)
	duration = 60.minutes

	event_schema = EventSchema.create!({
		title: Faker::TvShows::BreakingBad.unique.episode, # unique
		description: Faker::Movies::Hobbit.quote,
		church_id: church.id,
		duration: duration,
		start_date: start_date,
		end_date: start_date + duration,
		location: Faker::Movies::Hobbit.location,
		color: EventSchema.colors.to_a.sample[1]
	})
end