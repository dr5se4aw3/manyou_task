class StatusValidator < ActiveModel::Validator
  def validate(record)
    unless ["未着手","着手中","完了"].include?(record.status)
      record.errors[:status] << 'が不正です。'
    end
  end
end

class Task < ApplicationRecord
  belongs_to :user
  has_many :label_on_tasks, dependent: :destroy
  has_many :labels, through: :label_on_tasks
  accepts_nested_attributes_for :label_on_tasks, reject_if: :all_blank
  enum priority:{ 低: 0, 中: 1, 高: 2}

  validates :title, presence: true, length: { maximum: 30 }
  validates :detail, presence: true, length: { maximum: 255 }
  validates :deadline, presence: true
  include ActiveModel::Validations
  validates :status, presence: true
  validates_with StatusValidator
  validates :priority,presence: true


  scope :search_with_title, -> (title){where("title LIKE ?", "%#{title}%")}
  scope :search_with_status, -> (status){where(status: status)}
  scope :search_with_label, -> (label){where(id: LabelOnTask.where(label_id: label).pluck(:task_id))}

end
