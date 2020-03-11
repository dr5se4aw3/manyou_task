class User < ApplicationRecord
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
  before_validation { email.downcase! }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  before_destroy :last_admin!
  before_update :last_admin!

  private

  def last_admin!
    target = User.find_by(id: self.id)

    if User.where(admin: true).count <= 1
      if self.admin || (target.admin && !self.admin)
        raise ActiveRecord::Rollback
      end
    end
  end
end
