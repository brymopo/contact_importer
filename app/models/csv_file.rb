class CsvFile < ApplicationRecord
  include AASM

  aasm do
    state :on_hold, initial: true
    state :processing, :finished, :failed

    event :process do
      transitions from: :on_hold, to: :processing
    end

    event :mark_finished do
      transitions from: :processing, to: :finished
    end

    event :mark_failed do
      transitions from: :processing, to: :failed
    end
  end

  belongs_to :user
  has_one_attached :file
  validates :file, presence: true, file: true, size: true
end
