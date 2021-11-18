class Contact < ApplicationRecord
  belongs_to :user
  validates_presence_of :date_of_birth
  validates :name,
            presence: true,
            format: {
              with: /\A[a-zA-Z0-9 -]+\z/,
              message: "Name must be alphanumeric ('-' is allowed)"
            }
  validates :address, presence: true
  validates :email,
            presence: true,
            "valid_email_2/email": true,
            uniqueness: { scope: [:user_id] }
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
              message: "Not a CC number or not an approved franchise",
              if: :run_validation?
            }
  after_validation :set_cc_info
  before_save :encrypt_credit_card

  private

  def run_validation?
    credit_card_key.nil?
  end

  def set_cc_info
    return unless new_record?

    detector = CreditCardValidations::Detector.new(credit_card)
    self.franchise = detector.brand
    self.last_four = detector.number[-4...detector.number.size]
  end

  def encrypt_credit_card
    pkey_path = Rails.root.join("config", "public.pem")
    public_key = OpenSSL::PKey::RSA.new(File.read(pkey_path))
    cipher = OpenSSL::Cipher::Cipher.new('aes-256-cbc')
    cipher.encrypt
    cipher.key = random_key = cipher.random_key
    cipher.iv = random_iv = cipher.random_iv

    self.credit_card = cipher.update(self.credit_card)
    self.credit_card << cipher.final

    self.credit_card_key = public_key.public_encrypt(random_key)
    self.credit_card_iv = public_key.public_encrypt(random_iv) 
  end
end
