class Label < ApplicationRecord
  has_many :label_on_tasks, dependent: :destroy
  has_many :tasks, through: :label_on_tasks
  validates :title, presence: true, uniqueness: true, length: { maximum: 30 }
end
