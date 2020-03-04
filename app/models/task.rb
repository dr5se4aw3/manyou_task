class Validator < ActiveModel::Validator
  def validate(record)
    unless ["未着手","着手中","完了"].include?(record.status)
      record.errors[:status] << 'が不正です。'
    end
  end
end

class Task < ApplicationRecord
  enum priority:{ "低": 0, "中": 1, "高": 2}

  validates :title, presence: true, length: { maximum: 30 }
  validates :detail, presence: true, length: { maximum: 255 }
  validates :deadline, presence: true
  include ActiveModel::Validations
  validates_with Validator

  scope :search_with_title_status, -> (title, status){where("title LIKE ?", "%#{title}%").where(status: status)}
  scope :search_with_title, -> (title){where("title LIKE ?", "%#{title}%")}
  scope :search_with_status, -> (status){where(status: status)}
end
