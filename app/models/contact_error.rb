class ContactError < ApplicationRecord
  belongs_to :user
  validates :contact_identifier, presence: true
end
