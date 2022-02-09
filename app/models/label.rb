class Label < ApplicationRecord
  validates :name, presence: true, length: { maxmum: 10 }, uniquness: true
  has_many :labelings, dependent: :destroy
  has_many :tasks, through: :labelings, source: :task
end
