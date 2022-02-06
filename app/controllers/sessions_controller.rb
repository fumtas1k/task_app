class SessionsController < ApplicationController
  skip_before_action :login_required, only: %i[ new create ]
  before_action :logout_required, only: %i[ new create ]
  def new
  end
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:success] = t ".message"
      redirect_to user_path(user.id)
    else
      flash.now[:danger] = t ".caution"
      render :new
    end
  end
  def destroy
    session.delete(:user_id)
    flash[:success] = t ".message"
    redirect_to new_session_path
  end
end
