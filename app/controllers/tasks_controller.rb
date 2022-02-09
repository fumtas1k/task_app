class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  before_action :author_or_admin_required, only: %i[ show edit update destroy ]
  helper_method :sort_column, :sort_direction

  def index
    @tasks = if params[:clear] || params[:task].nil?
      @search_params = nil
      if current_user.admin?
        Task.includes(:user).change_sort(sort_column, sort_direction).page(params[:page])
      else
        current_user.tasks.change_sort(sort_column, sort_direction).page(params[:page])
      end
    else
      @search_params = {task: search_params}
      if current_user.admin?
        Task.includes(:user).search(search_params[:name], search_params[:status], search_params[:label_id]).change_sort(sort_column, sort_direction).page(params[:page])
      else
        current_user.tasks.search(search_params[:name], search_params[:status], search_params[:label_id]).change_sort(sort_column, sort_direction).page(params[:page])
      end
    end
  end

  def show
  end

  def new
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = "#{@task.name} #{t ".message"}"
      redirect_to @task
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = "#{@task.name} #{t ".message"}"
      redirect_to @task
    else
      render :edit
    end
  end

  def destroy
    task_name = @task.name
    @task.destroy
    flash[:danger] = "#{task_name} #{t ".message"}"
    redirect_to root_path
  end

  private
  def task_params
    params.require(:task).permit(:name, :description, :expired_at, :status, :priority, label_ids: [])
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def author_or_admin_required
    @user = Task.find_by(id: params[:id])&.user
    redirect_to tasks_path unless current_user == @user || current_user.admin?
  end
end
