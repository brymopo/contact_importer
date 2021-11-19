# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

bot = FactoryBot
user = User.create(email: "user@example.com", password: "abc123")

%w[pedro-perez mario-barajas pedro-antonio maria-carvajal susana-lopez
margarita-suarez andres-fernandez juana-loza
].each do |name|
  bot.create(:contact, user: user, name: name)
end

25.times do
  on_hold = bot.create(:csv_file, user: user)
  processing = bot.create(:csv_file, user: user)
  failed = bot.create(:csv_file, user: user)
  finished = bot.create(:csv_file, user: user)

  processing.process!
  failed.process!
  finished.process!

  failed.mark_failed!
  finished.mark_finished!
end
