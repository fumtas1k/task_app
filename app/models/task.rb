class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, presence: true
  validates :expired_at, presence: true
  validates :status, presence: true
  enum status: { todo: 0, doing: 10, done: 20 }, _prefix: true # 今後、追加できるよう10毎とした
end
