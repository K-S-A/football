FactoryGirl.define do
  factory :user, aliases: [:rated_user] do
    email { Faker::Internet.email }
    password { Faker::Internet.password(10, 20) }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    img_link { Faker::Avatar.image }

    factory :admin do
      admin true
    end
  end
end
