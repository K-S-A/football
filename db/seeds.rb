if ENV['users']
  5.times do
    User.create(
      email: Faker::Internet.email,
      password: Faker::Internet.password(10, 20),
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name)
  end
end
