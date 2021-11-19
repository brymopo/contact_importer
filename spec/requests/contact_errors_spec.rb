require 'rails_helper'

RSpec.describe ContactErrorsController, type: :request do
  let(:user) { create(:user) }

  describe "GET /index" do
    subject { get contact_errors_path }

    context "when user is not logged in" do
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context "when user is logged in and has no failed contact" do
      before do
        sign_in user
        subject
      end

      it { is_expected.to render_template(:index) }
      it { expect(assigns(:failed_contacts)).not_to be_nil }
      it { expect(assigns(:failed_contacts)).to be_blank }
    end

    context "when user is logged in and has files" do
      let!(:errors) { create_list(:contact_error, 25, user: user) }

      before do
        sign_in user
        subject
      end

      it { is_expected.to render_template(:index) }
      it { expect(assigns(:failed_contacts)).to match_array(errors.first(20)) }
      it { expect(assigns(:failed_contacts)).not_to include(errors.last(5)) }
      it "results are the right kind" do
        assigns(:failed_contacts).each do |result|
          expect(result).to be_kind_of(ContactError)
        end
      end
    end
  end
end
