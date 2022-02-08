class ApplicationController < ActionController::Base
  before_action :basic_auth unless Rails.env.test?
  before_action :login_required
  include SessionsHelper

  private
  def basic_auth
    authenticate_or_request_with_http_basic do |name, password|
      name == ENV["BASIC_AUTH_NAME"] && password == ENV["BASIC_AUTH_PASSWORD"]
    end
  end

  def login_required
    redirect_to new_session_path if !current_user
  end
  def logout_required
    redirect_back fallback_location: root_path if current_user
  end

  def search_params
    params.require(:task).permit(:name, :status)
  end
  def sort_column
    Task.column_names.include?(params[:column]) ? params[:column] : "created_at"
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
