module TasksHelper
  def sort_by(column, column_name, hash_params={})
    direction = (sort_column == column && sort_direction == "desc") ? "asc" : "desc"
    link_to column_name, { column: column, direction: direction }.merge(Hash(hash_params))
  end
end
