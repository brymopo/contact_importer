class Contact < ApplicationRecord
  validates_presence_of :date_of_birth, :franchise, :credit_card
  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9 -]+\z/ }
  validates :address, presence: true
  validates :email, presence: true, "valid_email_2/email": true
  validates :phone,
            presence: true,
            format: {
              with: /\A\(\+\d{2}\)\s(?:(?:(?:\d{3}-){2}\d{2}-\d{2}){1}|(?:(?:\d{3}\s){2}\d{2}\s\d{2}){1})\z/
            }
end
