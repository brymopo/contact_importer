require 'rails_helper'

RSpec.describe ContactError, type: :model do
  describe "relations" do
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:contact_identifier) }
  end
end
