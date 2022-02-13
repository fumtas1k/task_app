class Label < ApplicationRecord
  validates :name, presence: true, length: { maximum: 10 }, uniqueness: true
  has_many :labelings, dependent: :destroy
  has_many :tasks, through: :labelings, source: :task
end
