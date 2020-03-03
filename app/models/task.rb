class StatusValidator < ActiveModel::Validator
  def validate(record)
    unless ["未着手","着手中","完了"].include?(record.status)
      record.errors[:status] << 'が不正です。'
    end
  end
end


class Task < ApplicationRecord
  validates :title, presence: true, length: { maximum: 30 }
  validates :detail, presence: true, length: { maximum: 255 }
  validates :deadline, presence: true
  include ActiveModel::Validations
  validates_with StatusValidator
end
