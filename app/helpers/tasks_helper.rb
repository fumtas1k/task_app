module TasksHelper
  def sort_by(column, column_name, hash_params={})
    if (sort_column == column && sort_direction == "desc")
      direction, column_name = "asc", "#{column_name}▼"
    else
      direction, column_name = "desc", "#{column_name}▲"
    end
    link_to column_name, { column: column, direction: direction }.merge(Hash(hash_params))
  end

  def hash_nil_guard(hash, *keys)
    ans = Hash(hash)
    keys.each do |key|
      return nil unless [Hash, ActionController::Parameters].include?(ans.class)
      ans = ans[key]
    end
    return ans
  end

  def set_priority_color(priority)
    priority_colors = Hash[Task.priorities.keys.zip(%i[green orange red])]
    "font_#{priority_colors[priority]}" if Task.priorities.keys.include?(priority)
  end

  def set_status_color(status)
    status_colors = Hash[Task.statuses.keys.zip(%i[red orange green])]
    "font_#{status_colors[status]}" if Task.statuses.keys.include?(status)
  end

  def set_priority(priority)
    priority || Task.priorities.keys[1]
  end

  def color_activate(expected, actual)
    "active" if expected == actual
  end
end
