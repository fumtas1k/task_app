class TasksController < ApplicationController
  before_action :set_task, only: %i[show edit update]
  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      flash[:succss] = "#{@task.name} を新規登録しました!"
      redirect_to @task
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = "#{@task.name} を編集しました!"
      redirect_to @task
    else
      render :edit
    end
  end

  private
  def task_params
    params.require(:task).permit(:name, :description)
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
