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