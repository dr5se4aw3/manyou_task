class Label < ApplicationRecord
  has_many :label_on_tasks, dependent: :destroy
  has_many :related_tasks, through: :label_on_tasks, source: :task
  validates :title, uniqueness: true
end
