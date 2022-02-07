class Admin::UsersController < ApplicationController
  before_action :admin_required
  before_action :set_user, only: %i[ edit update destroy ]
  def index
    @users = User.order(:id).includes(:tasks).page(params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "#{@user.name}を#{t ".message" }"
      redirect_to admin_users_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "#{@user.name}の#{t ".message" }"
      redirect_to admin_users_path
    else
      if @user.errors.count == 0
        flash.now[:danger] = t ".caution"
      end
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = "#{@user.name}を#{t ".message" }"
      redirect_to admin_users_path
    else
      flash[:danger] = t ".caution"
      redirect_back fallback_location: admin_users_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
  def set_user
    @user = User.find(params[:id])
  end
  def admin_required
    redirect_to tasks_path unless current_user.admin?
  end
end
