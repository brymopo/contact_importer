FactoryBot.define do
  factory :contact_error do
    name { [Faker::Lorem.sentence] }
    phone { [Faker::Lorem.sentence] }
    address { [Faker::Lorem.sentence] }
    email { [Faker::Lorem.sentence] }
    credit_card { [Faker::Lorem.sentence] }
    date_of_birth { [Faker::Lorem.sentence] }
    contact_identifier { Faker::Lorem.sentence }
    user
  end
end