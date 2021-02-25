class Admin::NewsController < ApplicationController
  before_action :authenticate_user!
  before_action :if_not_admin

  def new
    @news = News.new
  end

  def create
    @news = News.new(news_params)
    # お知らせは一つしか存在できない。
    if News.count == 0
      if @news.save
        flash[:success] = "お知らせを作成しました"
        redirect_to root_path
      else
        render 'new'
      end
    else
      flash[:danger] = "お知らせは一つしか公開できません"
      redirect_to root_path
    end
  end

  def edit
    @news = News.find(params[:id])
  end

  def update
    @news = News.find(params[:id])
    if @news.update(news_params)
      flash[:success] = "お知らせは更新されました！"
      redirect_to @news
    else
      render 'edit'
    end
  end

  def destroy
    News.find(params[:id]).destroy
    flash[:success] = "お知らせを削除しました"
    redirect_to root_path
  end

  private
  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end

  def news_params
    params.require(:news).permit(:title, :message)
  end
end
