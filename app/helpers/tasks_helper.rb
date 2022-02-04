module TasksHelper
  def sort_by(column, column_name, hash_params={})
    direction = (sort_column == column && sort_direction == "desc") ? "asc" : "desc"
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
end
