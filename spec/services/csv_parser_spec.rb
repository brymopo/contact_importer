require "rails_helper"

RSpec.describe CsvParser, type: :model do
  describe ".call" do
    let(:headers) { {} }
    let(:file_name) { "right_headers.csv" }
    let(:user) { create(:user) }
    let(:csv_file) do
      record = CsvFile.new(user_id: user.id)
      record.file.attach(
        io: File.open(Rails.root.join("spec", "fixtures", "files", file_name)),
        filename: file_name,
        content_type: "text/csv"
      )
      record.save
      record
    end
    let(:params) do
      {
        user_id: user.id,
        file_id: csv_file.id,
        headers: headers
      }
    end

    it "when headers are default and data correct" do
      expect(csv_file).to be_valid
      expect { described_class.call(params) }.to change(Contact, :count).by(6)
      expect(csv_file.reload).to be_finished
    end

    context "when headers are default and all data wrong" do
      let(:file_name) { "right_headers_wrong_info.csv" }

      it "scenario" do
        expect(csv_file).to be_valid
        expect { described_class.call(params) }.not_to change(Contact, :count)
        expect(csv_file.reload).to be_failed
      end
    end

    context "when headers are default and only one is right" do
      let(:file_name) { "right_headers_one_right.csv" }

      it "scenario" do
        expect(csv_file).to be_valid
        expect { described_class.call(params) }.to change(Contact, :count).by(1)
        expect(csv_file.reload).to be_finished
      end
    end

    context "when file is headers only (default)" do
      let(:file_name) { "headers_only.csv" }

      it "scenario" do
        expect(csv_file).to be_valid
        expect { described_class.call(params) }.not_to change(Contact, :count)
        expect(csv_file.reload).to be_on_hold
      end
    end

    context "when file is empty" do
      let(:file_name) { "empty.csv" }

      it "scenario" do
        expect(csv_file).to be_valid
        expect { described_class.call(params) }.not_to change(Contact, :count)
        expect(csv_file.reload).to be_on_hold
      end
    end

    context "when headers are different and data correct" do
      let(:file_name) { "different_headers.csv" }
      let(:headers) do
        {
          name: "nombre",
          phone: "telefono",
          address: "direccion",
          email: "correo",
          date_of_birth: "fecha de nacimiento",
          credit_card: "tarjeta de credito"
        }
      end

      it "scenario" do
        expect(csv_file).to be_valid
        expect { described_class.call(params) }.to change(Contact, :count).by(6)
        expect(csv_file.reload).to be_finished
      end
    end
  end
end