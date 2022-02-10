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
  has_many :labelings, dependent: :destroy
  has_many :labels, through: :labelings, source: :label

  scope :change_sort, -> (column, direction) { order("#{column} #{direction}") }
  scope :search, -> (name, status, label_id) {
    status_num = self.statuses[status]
    search_args = [
      ["%#{self.sanitize_sql_like(name || "")}%", "tasks.name LIKE ?"],
      [status_num, "tasks.status = ?"],
      [label_id, "labels.id = ?"],
    ]
    search_sql = [""]
    search_args.each do |value, text|
      if value.present? && value != "%%"
        search_sql[0] = search_sql[0].present? ? [search_sql[0], text].join(" AND ") : text
        search_sql << value
      end
    end
    if search_sql[0].present?
        joins(:labels).where(search_sql)
    end
  }
end
