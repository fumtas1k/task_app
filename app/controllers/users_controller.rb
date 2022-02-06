class UsersController < ApplicationController
  skip_before_action :login_required, only: %i[ new create ]
  before_action :logout_required, only: %i[ new create ]
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :ensure_user_required, only: %i[ show edit update destroy ]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:success] = t ".message"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = t ".message"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:danger] = t ".message"
    redirect_to new_user_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  def set_user
    @user = User.find(params[:id])
  end
  def ensure_user_required
    redirect_to tasks_path if current_user != @user
  end
end
