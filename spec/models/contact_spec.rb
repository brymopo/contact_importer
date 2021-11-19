require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
  end

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

    context "date_of_birth" do
      let(:tomorrow) { Date.tomorrow.iso8601[0...10] }

      it { is_expected.to allow_value("1987-09-12").for(:date_of_birth) }
      it { is_expected.to allow_value("1900-01-31").for(:date_of_birth) }
      it { is_expected.to allow_value("1969-04-28").for(:date_of_birth) }
      it { is_expected.to allow_value("2005-10-09").for(:date_of_birth) }
      it { is_expected.to allow_value("2017-12-31").for(:date_of_birth) }
      it { is_expected.to allow_value("1993-09-13").for(:date_of_birth) }
      it { is_expected.to allow_value("1970-05-31").for(:date_of_birth) }
      it { is_expected.to allow_value("1995-08-27").for(:date_of_birth) }
      it { is_expected.to allow_value("1982-11-10").for(:date_of_birth) }      
      it { is_expected.not_to allow_value(tomorrow).for(:date_of_birth) }
      it { is_expected.not_to allow_value("2020-02-31").for(:date_of_birth) }
      it { is_expected.not_to allow_value("2020-19-31").for(:date_of_birth) }
      it { is_expected.not_to allow_value("1899-12-31").for(:date_of_birth) }
      it { is_expected.not_to allow_value(1234567890).for(:date_of_birth) }
      it { is_expected.not_to allow_value("alphanumeric 0123456789").for(:date_of_birth) }
      it { is_expected.not_to allow_value("with%_sp$c!@l%_char-acters").for(:date_of_birth) }
      it { is_expected.not_to allow_value("1987-09-12T00:00:00+00:00").for(:date_of_birth) }
    end
  end

  describe ".create" do
    let(:cc_factory) { CreditCardValidations::Factory }

    context "sets franchise on create" do
      let(:user) { create(:user) }
      let(:number) { cc_factory.random(:visa) }
      let(:attributes) do
        attributes_for(:contact, credit_card: number).merge(user_id: user.id)
      end

      subject { described_class.create(attributes) }

      it { is_expected.to be_valid }
      it { expect(subject.franchise).to eq("visa") }
      it { expect(subject.last_four).to eq(number[-4...number.size]) }
      it { expect(subject.credit_card).not_to eq(number) }
    end

    context "when two contacts have the same email, different users" do
      let(:user1) { create(:user) }
      let(:user2) { create(:user) }
      let(:contact1) { create(:contact, email: "same@example.com", user: user1) }
      let(:contact2) { create(:contact, email: "same@example.com", user: user2) }

      it { expect(contact1).to be_valid }
      it { expect(contact2).to be_valid }
      it { expect(contact1.email).to eq(contact2.email) }
      it { expect(user1.id).not_to eq(user2.id) }
      it { expect(contact1.user.id).to eq(user1.id) }
      it { expect(contact2.user.id).to eq(user2.id) }
    end

    context "when two contacts have the same email, same user" do
      let(:user) { create(:user) }
      let(:contact1) { create(:contact, email: "same@example.com", user: user) }
      let(:attributes) { attributes_for(:contact, email: contact1.email).merge(user_id: user.id) }

      subject { described_class.create(attributes) }

      it { expect(contact1).to be_valid }
      it { is_expected.not_to be_valid }
      it { is_expected.not_to be_persisted }
      it { expect(subject.email).to eq(contact1.email) }
    end
  end
end
