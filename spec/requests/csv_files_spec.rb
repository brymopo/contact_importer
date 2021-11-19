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
end
