class ZoomsController < ApplicationController
  before_action :authenticate_user!, only: [:edit,:update,:create,:new,:destory] # indexはランディングページを兼ねている
  before_action :correct_user, only: [:edit,:destroy, :update]

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
    @zoom.university_id = current_user.university_id # zoomのuniversity_idはユーザーと同じ
    # @zoom.host_url = parseURL["start_url"]
    # @zoom.join_url = parseURL["join_url"]
    # if current_user.zoom.present?
    #   flash[:danger] = "zoomの部屋を複数作ることはできません(過去に作ったzoomを削除してから再度zoomを作成してください)"
    #   render new_zoom_path
    # els
    if @zoom.save
      flash[:notice] = "zoomの部屋が作成されました"
      redirect_to zooms_path
    else
      render :new
    end

  end

  def new
    @zoom = Zoom.new
  end

  def index
    if user_signed_in?
      @zooms = Zoom.where(university_id: current_user.university_id).or(Zoom.where(is_public: :true)).includes([:user]).order(:start_time) #自分の大学のzoomもしくはis_publicがtrueのzoomを一覧を表示
      @news = News.where(university_id: current_user.university_id)
      @slides = SlideContent.where(university_id: current_user.university.id).order(updated_at: :desc)
    end
  end
  
  def edit
    @zoom = Zoom.find(params[:id])
  end

  def update
    @zoom = Zoom.find(params[:id])
    if @zoom.update(zoom_params)
      flash[:notice] = "zoom情報を更新しました"
      redirect_to zooms_path
    else
      render :edit
    end
  end

  def destroy
    @zoom=Zoom.find(params[:id])
    if @zoom.destroy
      flash[:notice]="zoomは削除されました"
      redirect_to zooms_path
    else
      flash[:danger]="zoomは削除できませんでした"
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
    params.require(:zoom).permit(:join_url, :user_id, :title, :start_time, :end_time, :is_public)
  end

  def correct_user
    @zoom = Zoom.find(params[:id])
    redirect_to zooms_path unless @zoom.user==current_user
  end
end
