require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe "validations" do
    context "presence" do
      attributes = %i[name date_of_birth phone address email credit_card]
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

    context "credit_card_number" do
      it { is_expected.to allow_value("371449635398431").for(:credit_card) }
      it { is_expected.to allow_value("30569309025904").for(:credit_card) }
      it { is_expected.to allow_value("6011783375412756207").for(:credit_card) }
      it { is_expected.to allow_value("3530111333300000").for(:credit_card) }
      it { is_expected.to allow_value("5555555555554444").for(:credit_card) }
      it { is_expected.to allow_value("4111111111111111").for(:credit_card) }

      it { is_expected.not_to allow_value("notacreditcard").for(:credit_card) }

      context "when franchise is not accepted" do
        let(:cc_factory) { CreditCardValidations::Factory }

        it { is_expected.not_to allow_value(cc_factory.random(:maestro)).for(:credit_card) }
        it { is_expected.not_to allow_value(cc_factory.random(:mir)).for(:credit_card) }
        it { is_expected.not_to allow_value(cc_factory.random(:rupay)).for(:credit_card) }
        it { is_expected.not_to allow_value(cc_factory.random(:switch)).for(:credit_card) }
      end
    end
  end

  describe ".create" do
    let(:cc_factory) { CreditCardValidations::Factory }

    context "sets franchise on create" do
      let(:number) { cc_factory.random(:visa) }
      let(:attributes) { attributes_for(:contact, credit_card: number).except(:id) }

      subject do
        described_class.create(attributes)
      end

      it { is_expected.to be_valid }
      it { expect(subject.franchise).to eq("visa") }
      it { expect(subject.last_four).to eq(number[-4...number.size]) }
      it { expect(subject.credit_card).not_to eq(number) }
    end
  end
end
