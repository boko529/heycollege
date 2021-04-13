class UserZoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    zoom = Zoom.find(params[:id])
    if zoom.user == current_user
      # flash[:danger] = "ホストはすでにzoomに参加しています" コレいらなくない？
      redirect_to zoom.join_url
    else
      if current_user.belongs_zoom?(zoom)
        redirect_to zoom.join_url
      else
        current_user.join_zoom(zoom)
        cnt = zoom.count + 1
        if zoom.update(count: cnt)
          zoom.user.zoom_h_point # zoomのホストにポイントを付与
          current_user.zoom_a_point # zoomの参加者にポイントを付与
          redirect_to zoom.join_url
        else
          @zooms = Zoom.all
          flash[:danger] = "zoomに参加できませんでした。"
          render 'zooms/index'
        end
      end
    end
  end
end
