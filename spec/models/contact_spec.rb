require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe "validations" do
    context "presence" do
      attributes = %i[name date_of_birth phone address franchise email credit_card]
      attributes.each do |attribute|
        it { is_expected.to validate_presence_of(attribute) }
      end
    end

    context "format" do
      context "name" do
        it { is_expected.to allow_value("with no special characters").for(:name) }
        it { is_expected.to allow_value("With Uppercase Letters").for(:name) }
        it { is_expected.to allow_value("With-dash").for(:name) }
        it { is_expected.to allow_value(1234567890).for(:name) }
        it { is_expected.to allow_value("alphanumeric 0123456789").for(:name) }
        it { is_expected.not_to allow_value("with%_sp$c!@l%_char-acters").for(:name) }
      end

      context "address" do
        it { is_expected.to allow_value("123 fake street - apt 123").for(:address) }
        it { is_expected.not_to allow_value("").for(:address) }
        it { is_expected.not_to allow_value(" ").for(:address) }
      end

      context "email" do
        it { is_expected.to allow_value("me@fake.com").for(:email) }
        it { is_expected.to allow_value("me-two@example.com").for(:email) }
        it { is_expected.to allow_value("me.two@example.com").for(:email) }
        it { is_expected.to allow_value("me_two@example.com").for(:email) }
        it { is_expected.not_to allow_value("me.@example.com").for(:email) }        
        it { is_expected.not_to allow_value("me.@.com").for(:email) }
        it { is_expected.not_to allow_value("me@example").for(:email) }
        it { is_expected.not_to allow_value("me@.com").for(:email) }
        it { is_expected.not_to allow_value("me.two@example.com.").for(:email) }
        it { is_expected.not_to allow_value(".me.two@example.com").for(:email) }
      end

      context "phone" do
        it { is_expected.to allow_value("(+57) 320 432 05 09").for(:phone) }
        it { is_expected.to allow_value("(+57) 320-432-05-09").for(:phone) }
        it { is_expected.not_to allow_value("(+57) 320-432 05-09").for(:phone) }
        it { is_expected.not_to allow_value("(+57) 320 432-05 09").for(:phone) }
        it { is_expected.not_to allow_value(" (+57) 320 432 05 09").for(:phone) }
        it { is_expected.not_to allow_value(" (+57) 320-432-05-09").for(:phone) }
        it { is_expected.not_to allow_value("(+5) 320 432 05 09").for(:phone) }
        it { is_expected.not_to allow_value("(+5) 320-432-05-09").for(:phone) }
        it { is_expected.not_to allow_value("+(57) 320 432 05 09").for(:phone) }
        it { is_expected.not_to allow_value("+(57) 320-432-05-09").for(:phone) }
      end
    end
  end
end
