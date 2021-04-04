class Admin::SlideContentsController < ApplicationController
  before_action :authenticate_user!
  before_action :if_not_admin
  
  def index
    @slides = SlideContent.order(updated_at: :desc)
  end

  def new
    @slide = SlideContent.new
  end

  def create
    @slide = SlideContent.new(slide_params)
    if @slide.save
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
    @slide = SlideContent.find(params[:id])
    if @slide.update(slide_params)
    flash[:success] = "スライドは更新されました！"
    redirect_to admin_slide_contents_path
    else
      render 'edit'
    end
  end

  def destroy
    SlideContent.find(params[:id]).destroy
    flash[:success] = "スライドを削除しました"
    redirect_to admin_slide_contents_path
  end

  private
  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end

  def slide_params
    params.require(:slide_content).permit(:slide_image, :link, :university_id)
  end
end
