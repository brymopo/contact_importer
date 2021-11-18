FactoryBot.define do
  factory :contact do
    name { "John Smith" }
    phone { "(+57) 320 432 05 09" }
    address { Faker::Address.street_address }
    email { Faker::Internet.email }
    credit_card { CreditCardValidations::Factory.random(:visa) }
    date_of_birth { Faker::Date.birthday(min_age: 18, max_age: 65) }
  end
end
