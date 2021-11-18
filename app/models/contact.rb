class Contact < ApplicationRecord
  validates_presence_of :date_of_birth
  validates :name,
            presence: true,
            format: {
              with: /\A[a-zA-Z0-9 -]+\z/,
              message: "Name must be alphanumeric ('-' is allowed)"
            }
  validates :address, presence: true
  validates :email, presence: true, "valid_email_2/email": true
  validates :phone,
            presence: true,
            format: {
              with: /\A\(\+\d{2}\)\s(?:(?:(?:\d{3}-){2}\d{2}-\d{2}){1}|(?:(?:\d{3}\s){2}\d{2}\s\d{2}){1})\z/,
              message: "does not meet required format"
            }
  validates :credit_card,
            presence: true,
            credit_card_number: {
              brands: %i[amex diners discover jcb mastercard visa],
              message: "Not a CC number or not an approved franchise"
            }
  before_create :set_cc_info

  private

  def set_franchise
    detector = CreditCardValidations::Detector.new(credit_card)
    self.franchise = detector.brand
  end

  def encrypt_credit_card
    credit_card
  end

  def set_cc_info
    set_franchise
    encrypt_credit_card
  end
end
