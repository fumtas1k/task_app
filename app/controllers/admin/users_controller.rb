class Admin::UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update destroy ]
  def index
    @users = User.includes(:tasks).page(params[:page])
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
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:danger] = "#{@user.name}は#{t ".message" }"
    redirect_to admin_users_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
  def set_user
    @user = User.find(params[:id])
  end
end
