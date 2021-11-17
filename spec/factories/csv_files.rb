FactoryBot.define do
  factory :csv_file do
    user
    after(:build) do |csv_file|
      csv_file.file.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "files", "sample.csv")),
        filename: "sample.csv",
        content_type: "text/csv"
      )
    end
  end
end
