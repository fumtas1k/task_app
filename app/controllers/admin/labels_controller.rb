class Admin::LabelsController < ApplicationController
  before_action :admin_required
  before_action :set_label, only: %i[ edit update destroy ]
  def index
    @labels = Label.all
  end

  def new
    @label = Label.new
  end

  def create
    @label = Label.new(label_params)
    if @label.save
      redirect_to admin_labels_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @label.update(label_params)
      redirect_to admin_labels_path
    else
      render :edit
    end
  end

  def destroy
    @label.destroy
    flash[:success] = t(".message")
    redirect_to admin_labels_path
  end

  private
  def label_params
    params.require(:label).permit(:name)
  end

  def set_label
    @label = Label.find(params[:id])
  end
end
