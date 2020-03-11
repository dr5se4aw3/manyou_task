class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
  before_validation { email.downcase! }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  after_destroy :last_admin!
  after_update :last_admin!

  private
  def last_admin!
    if User.where(admin: true).count < 1
      raise ActiveRecord::Rollback
    end
  end
end
