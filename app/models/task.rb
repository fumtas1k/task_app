class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, presence: true
  validates :expired_at, presence: true
  validates :status, presence: true
  enum status: { todo: 0, doing: 10, done: 20 }, _prefix: true # 今後、追加できるよう10毎とした
  validates :priority, presence: true
  enum priority: { low: 0, medium: 10, high: 20 }, _prefix: true
  attribute :priority, default: :high
  belongs_to :user

  scope :change_sort, -> (column, direction) { order("#{column} #{direction}") }
  scope :search, -> (name, status) {
    status_num = self.statuses[status]
    if name.nil? && status_num.nil?
      change_sort(sort_column, sort_direction)
    else
      search_sql = if name.present? && status_num.present?
        ["tasks.name LIKE ? AND tasks.status = ?", "%#{self.sanitize_sql_like(name)}%", "#{status_num}"]
      elsif name.present?
        ["tasks.name LIKE ?", "%#{self.sanitize_sql_like(name)}%"]
      elsif status_num.present?
        ["tasks.status = ?", "#{status_num}"]
      end
      where(search_sql)
    end
  }
end
