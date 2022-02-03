class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :description, presence: true
  validates :expired_at, presence: true
  validates :status, presence: true
  enum status: { todo: 0, doing: 10, done: 20 }, _prefix: true # 今後、追加できるよう10毎とした

  scope :change_sort, -> (column, direction) { order("#{column} #{direction}") }
  scope :search, -> (name, status, sort_column, sort_direction) {
    if name.nil? && status.nil?
      change_sort(sort_column, sort_direction)
    else
      search_sql = if name.present? && status.present?
        ["tasks.name LIKE ? AND tasks.status = ?", "%#{Task.sanitize_sql_like(name)}%", "#{status}"]
      elsif name.present?
        ["tasks.name LIKE ?", "%#{Task.sanitize_sql_like(name)}%"]
      elsif status.present?
        ["tasks.status = ?", "#{status}"]
      end
      where(search_sql).change_sort(sort_column, sort_direction)
    end
  }
end
