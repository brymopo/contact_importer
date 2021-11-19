FactoryBot.define do
  factory :contact do
    name { "John Smith" }
    phone { "(+57) 320 432 05 09" }
    address { Faker::Address.street_address }
    email { Faker::Internet.email }
    credit_card { CreditCardValidations::Factory.random(:visa) }
    date_of_birth { "1982-11-10" }
    user
  end
end
