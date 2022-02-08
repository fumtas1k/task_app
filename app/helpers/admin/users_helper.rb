module Admin::UsersHelper
  def choose_new_or_edit
    if %w[new create].include?(action_name)
      admin_users_path
    elsif %w[edit update].include?(action_name)
      admin_user_path(@user)
    end
  end
end
