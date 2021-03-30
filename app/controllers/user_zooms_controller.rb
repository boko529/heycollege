class UserZoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    zoom = Zoom.find(params[:id])
    if zoom.user == current_user
      @zoom = Zoom.new
      @user=current_user
      @zooms = Zoom.all
      flash[:danger] = "ホストはすでにzoomに参加しています"
      render 'zooms/index'
    else
      current_user.join_zoom(zoom)
      cnt = zoom.count + 1
      if zoom.update(count: cnt)
        redirect_to zoom.join_url
      else
        @zoom = Zoom.new
        @user=current_user
        @zooms = Zoom.all
        flash[:danger] = "zoomに参加できませんでした。"
        render 'zooms/index'
      end
    end
  end
end
