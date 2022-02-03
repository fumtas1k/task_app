class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update destroy]
  helper_method :sort_column, :sort_direction

  def index
    # @tasks = Task.all.order(created_at: :desc)
    @tasks = Task.all.order("#{sort_column} #{sort_direction}")
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:success] = "#{@task.name} #{t "tasks.new.message"}"
      redirect_to @task
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = "#{@task.name} #{t "tasks.edit.message"}"
      redirect_to @task
    else
      render :edit
    end
  end

  def destroy
    task_name = @task.name
    @task.destroy
    flash[:danger] = "#{task_name} #{t "tasks.delete.message"}"
    redirect_to root_path
  end

  private
  def task_params
    params.require(:task).permit(:name, :description, :expired_at, :status)
  end

  def set_task
    @task = Task.find(params[:id])
  end

  def sort_column
    Task.column_names.include?(params[:column]) ? params[:column] : "created_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
end
