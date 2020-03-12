class Label < ApplicationRecord
  has_many :label_on_tasks, dependent: :destroy
  has_many :tasks, through: :label_on_tasks
  validates :title, uniqueness: true
end
