require 'rails_helper'

RSpec.describe CsvFile, type: :model do
  describe "relationships" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_one_attached(:file) }
  end

  describe "validations" do
    let(:expected_errors) { ["can't be blank", "is not of type text/csv"] }

    subject { described_class.create }

    it { expect(subject.errors[:file]).to match_array(expected_errors) }

    context "when right type and size" do
      subject do
        record = build(:csv_file)
        record.validate
        record
      end

      it { expect(subject.errors[:file]).to be_empty }
    end

    context "when size is over 2 MB, add error" do
      subject do
        record = build(:csv_file)
        record.file.attach(
          io: File.open(Rails.root.join("spec", "fixtures", "files", "large_csv.csv")),
          filename: "large_csv.csv",
          content_type: "text/csv"
        )
        record.validate
        record
      end

      it { expect(subject.errors[:file]).to include("cannot be more than 2 MB") }
      it { expect(subject.errors[:file]).not_to include("is not of type text/csv") }
    end

    context "when type is not text/csv, add error" do
      subject do
        record = build(:csv_file)
        record.file.attach(
          io: File.open(Rails.root.join("spec", "fixtures", "files", "test_image.jpg")),
          filename: "test_image.jpg",
          content_type: "image/jpg"
        )
        record.validate
        record
      end

      it { expect(subject.errors[:file]).to include("is not of type text/csv") }
      it { expect(subject.errors[:file]).not_to include("cannot be more than 2 MB") }
    end

    context "when type is not text/csv and size is over 2 MB, add errors" do
      subject do
        record = build(:csv_file)
        record.file.attach(
          io: File.open(Rails.root.join("spec", "fixtures", "files", "large.jpg")),
          filename: "large.jpg",
          content_type: "image/jpg"
        )
        record.validate
        record
      end

      it { expect(subject.errors[:file]).to include("is not of type text/csv") }
      it { expect(subject.errors[:file]).to include("cannot be more than 2 MB") }
    end
  end
end
