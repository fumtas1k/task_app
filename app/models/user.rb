class User < ApplicationRecord
  before_validation { email.downcase! }
  before_destroy :admin_destroy_exist
  before_update :admin_update_exist

  validates :name, presence: true, length: { maximum: 30 }
  VALID_EMAIL_REGEX = /\A[\w+.-]+@[a-z\d-]+(\.[a-z\d-]+)*\.[a-z]+\z/i
  validates :email, presence: true, uniqueness: true,
            length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  has_secure_password
  validates :admin, inclusion: [true, false, "true", "false"]
  attribute :admin, default: false

  has_many :tasks, dependent: :destroy

  private
  def admin_destroy_exist
    throw(:abort) if self.admin? && User.where(admin: true).count == 1
  end
  def admin_update_exist
    admin_changes = [[true, "false"], [true, false]]
    throw(:abort) if admin_changes.include?(self.admin_change) && User.where(admin: true).count <= 1
  end
end
