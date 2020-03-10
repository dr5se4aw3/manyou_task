class NoAdminError < StandardError #例外クラスを継承
end
class User < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: true
  before_validation { email.downcase! }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  has_many :tasks, dependent: :destroy
  after_destroy :last_admin!
  after_update :last_admin!

  private
  def last_admin!
    if User.where(admin: true).count < 1
      raise ActiveRecord::Rollback
    end
  end
end
