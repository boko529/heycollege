class Admin::SlideContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :if_not_admin
  
  def index
    @slides = SlideContent.where(university_id: current_user.university.id)
  end

  def new
    @slide = SlideContent.new
  end

  def create
    @slide = SlideContent.new(slide_params)
    if @news.save
      flash[:success] = "スライドを追加しました"
      redirect_to admin_slide_contents_path
    else
      render 'new'
    end
  end

  def edit
    @slide = SlideContent.find(params[:id])
  end

  def update
  end

  def destroy
    SlideContent.find(params[:id]).destroy
    flash[:success] = "スライドを削除しました"
    redirect_to root_path
  end

  private
  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end

  def slide_params
    params.require(:slide_content).permit(:slide_image, :link, :university_id)
  end
end
