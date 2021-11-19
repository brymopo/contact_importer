require 'rails_helper'

RSpec.describe ContactsController, type: :request do
  let(:user) { create(:user) }

  describe "GET /index" do
    subject { get contacts_path }

    context "when user is not logged in" do
      it { is_expected.to redirect_to(new_user_session_path) }
    end

    context "when user is logged in and has no contacts" do
      before do
        sign_in user
        subject
      end

      it { is_expected.to render_template(:index) }
      it { expect(assigns(:contacts)).not_to be_nil }
      it { expect(assigns(:contacts)).to be_blank }
    end

    context "when user is logged in and has files" do
      let!(:test_contacts) { create_list(:contact, 25, user: user) }

      before do
        sign_in user
        subject
      end

      it { is_expected.to render_template(:index) }
      it { expect(assigns(:contacts)).to match_array(test_contacts.first(20)) }
      it { expect(assigns(:contacts)).not_to include(test_contacts.last(5)) }
      it "results are the right kind" do
        assigns(:contacts).each do |contact|
          expect(contact).to be_kind_of(Contact)
        end
      end
    end
  end
end
