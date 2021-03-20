class ZoomsController < ApplicationController
  def create
    # APIを用いてzoom作成
    # @api_key = "66aoWxi3R1CCqYtfXXX3vA"
    # @secret  = "eoEOrBqOAFBidWwGKmrB2HUHwb6YT8a6DRSV"
    # @jwt = self.GenerateJWT
    # @user_id = self.GetUserData(@jwt)
    # @meeting_url = "https://api.zoom.us/v2/users/#{@user_id}/meetings"

    # uri = URI.parse(@meeting_url)
    # http = Net::HTTP.new(uri.host, uri.port)

    # http.use_ssl = true
    # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    # req = Net::HTTP::Post.new(uri.path)
    # req["Authorization"] = "Bearer #{@jwt}"
    # aa = "Bearer #{@jwt}"
    # puts aa
    # req["Content-Type"] = "application/json"
    # req.body = {
    #     "type":1,
    #     }.to_json
    # res = http.request(req)
    # parseURL = JSON.parse(res.body)

    # 招待URLを用いてzoom作成
    @zoom = Zoom.new(zoom_params)
    @zoom.user_id = current_user.id
    # @zoom.host_url = parseURL["start_url"]
    # @zoom.join_url = parseURL["join_url"]
    # if current_user.zoom.present?
    #   flash[:danger] = "zoomの部屋を複数作ることはできません(過去に作ったzoomを削除してから再度zoomを作成してください)"
    #   render new_zoom_path
    # els
    if @zoom.end_time - @zoom.start_time <= 0
      flash[:danger] = "開始時刻と終了時刻がおかしいです。"
      render new_zoom_path
    elsif @zoom.start_time - Time.now < 0
      flash[:danger] = "開始時刻が現在時刻を過ぎています"
      render new_zoom_path
    else
      if @zoom.save
        flash[:notice] = "zoomの部屋が作成されました"
        redirect_to zoom_path(@zoom.id)
      else
        render :new
      end
    end

  end

  def new
    @zoom = Zoom.new
  end

  def index
    @zooms = Zoom.all
    @zoom = Zoom.new
    @user=current_user
  end
  
  def show
    @zoom = Zoom.find(params[:id])
  end
  
  def numbercount
    zoom = Zoom.find(params[:id])
    cnt = zoom.count + 1
    if zoom.update(count: cnt)
      redirect_to zoom.join_url
    else
      @zoom = Zoom.new
      @user=current_user
      @zooms = Zoom.all
      render :index
    end
  end

  def destroy
    @zoom=Zoom.find(params[:id])
    if @zoom.destroy
      flash[:notice]="zoomは削除されました"
      redirect_to zooms_path
    else
      render :index
    end
  end

  # require 'net/https'
  # require 'net/http'
  # require 'uri'
  # require 'json'

  # def GenerateJWT
  #   payload = { 
  #       iss: @api_key,
  #       exp: Time.now.to_i + 4 * 36000
  #   }
  #   token = JWT.encode payload, @secret, 'HS256'
  #   return token
  # end

  # def GetUserData(_token)
  #   uri = URI.parse("https://api.zoom.us/v2/users")
  #   request = Net::HTTP::Get.new(uri)
  #   request["Authorization"] = "Bearer "+_token
  #   req_options = {
  #       use_ssl: uri.scheme == "https",
  #   }
  #   response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  #       http.request(request)
  #   end
  #   result = JSON.parse(response.body)
  #   return result["users"][0]["id"].to_s
  # end

  private
  def zoom_params
    params.require(:zoom).permit(:join_url, :user_id, :title, :description, :start_time, :end_time)
    # params.require(:zoom).permit(:join_url,:host_url, :user_id, :title, :description)
  end
end
