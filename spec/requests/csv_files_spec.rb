require 'rails_helper'

RSpec.describe CsvFilesController, type: :request do

  let(:user) { create(:user) }

  describe "GET /index" do
    subject { get csv_files_path }

    context "when user is not logged in" do
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context "when user is logged in and has no files" do
      before do
        sign_in user
        subject
      end

      it { is_expected.to render_template(:index) }
      it { expect(assigns(:csv_files)).not_to be_nil }
      it { expect(assigns(:csv_files)).to be_blank }
    end

    context "when user is logged in and has files" do
      let!(:files) { create_list(:csv_file, 25, user: user) }

      before do
        sign_in user
        subject
      end

      it { is_expected.to render_template(:index) }
      it { expect(assigns(:csv_files)).to match_array(files.first(20)) }
      it { expect(assigns(:csv_files)).not_to include(files.last(5)) }
      it "results are the right kind" do
        assigns(:csv_files).each do |result|
          expect(result).to be_kind_of(CsvFile)
        end
      end
    end
  end

  describe "GET #New" do
    subject { get new_csv_file_path }

    context "when user is not logged in" do
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context "when user is logged in" do
      before do
        sign_in user
        subject
      end

      it { is_expected.to render_template(:new) }
      it { expect(assigns(:csv_file)).to be_kind_of(CsvFile) }
    end
  end

  describe "POST #create" do
    let(:file_name) { "right_headers.csv" }
    let(:file) { fixture_file_upload(file_name, 'text/csv', :binary) }
    let(:file_headers) { {} }
    let(:params) do
      {
        csv_file: {
        file: file
        }.merge(file_headers)
      }
    end

    subject { post csv_files_path, params: params }

    context "when user is not logged in" do
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context "when user is logged in" do
      before { sign_in user }

      context "and everything is right" do
        it { expect { subject }.to change(CsvFile, :count).by(1) }
        it { is_expected.to redirect_to(csv_files_path) }
      end

      context "and there's no file" do
        let(:file) { nil }

        it { expect { subject }.not_to change(CsvFile, :count) }
        it { is_expected.to render_template(:new) }
      end

      context "and there's headers" do
        let(:file_name) { "different_headers.csv" }
        let(:file_headers) do
          {
            name: "nombre",
            phone: "telefono",
            address: "direccion",
            email: "correo",
            date_of_birth: "fecha de nacimiento",
            credit_card: "tarjeta de credito"
          }
        end

        it { expect { subject }.to change(CsvFile, :count).by(1) }
        it { is_expected.to redirect_to(csv_files_path) }
      end
    end
  end
end
