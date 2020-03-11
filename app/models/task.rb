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
  enum priority:{ 低: 0, 中: 1, 高: 2}

  validates :title, presence: true, length: { maximum: 30 }
  validates :detail, presence: true, length: { maximum: 255 }
  validates :deadline, presence: true
  include ActiveModel::Validations
  validates_with StatusValidator
  validates :priority,presence: true


  scope :search_with_user_id, -> (cuurent_user_id){where(user_id: cuurent_user_id)}
  scope :search_with_title_status, -> (title, status, cuurent_user_id){where("title LIKE ?", "%#{title}%").where(status: status).where(user_id: cuurent_user_id)}
  scope :search_with_title, -> (title, cuurent_user_id){where("title LIKE ?", "%#{title}%").where(user_id: cuurent_user_id)}
  scope :search_with_status, -> (status, cuurent_user_id){where(status: status).where(user_id: cuurent_user_id)}
end
