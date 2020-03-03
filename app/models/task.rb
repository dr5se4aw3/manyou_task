class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :detail, presence: true, length: { maximum: 255 }
  validates :deadline, presence: true
end
