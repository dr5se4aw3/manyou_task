class StatusValidator < ActiveModel::Validator
  def validate(record)
    if record.status.empty?
      record.errors[:status] << 'を入力してください。'
    else
      unless ["未着手","着手中","完了"].include?(record.status)
        record.errors[:status] << 'が不正です。'
      end
    end
  end
end

class Task < ApplicationRecord
  belongs_to :user
  has_many :label_on_tasks, dependent: :destroy
  has_many :related_labels, through: :label_on_tasks, source: :label
  enum priority:{ 低: 0, 中: 1, 高: 2}

  validates :title, presence: true, length: { maximum: 30 }
  validates :detail, presence: true, length: { maximum: 255 }
  validates :deadline, presence: true
  include ActiveModel::Validations
  validates_with StatusValidator
  validates :priority,presence: true


#  scope :search_with_user_id, -> (cuurent_user_id){where(user_id: current_user.id)}
  scope :search_with_title_status, -> (title, status){where("title LIKE ?", "%#{title}%").where(status: status)}
  scope :search_with_title, -> (title){where("title LIKE ?", "%#{title}%")}
  scope :search_with_status, -> (status){where(status: status)}
end
