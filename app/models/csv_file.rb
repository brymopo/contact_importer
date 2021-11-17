class CsvFile < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  validates :file, presence: true, file: true, size: true
end
