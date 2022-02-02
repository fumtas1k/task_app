module TasksHelper
  def sort_by(column, column_name)
    direction = (sort_column == column && sort_direction == "desc") ? "asc" : "desc"
    link_to column_name, { column: column, direction: direction }
  end
end
