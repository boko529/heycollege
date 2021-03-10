class UsersController < ApplicationController   
  before_action :authenticate_user!, only: [:edit,:update]
  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews
  end

  def edit
    @user = User.find(params[:id])
    if @user == current_user
      render 'edit'
    else
      redirect_to user_path(current_user)
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user.id)
      flash[:notice] = "プロフィールを変更しました"
    else
      render 'edit'
    end
  end

  # 自分がフォローしているユーザー一覧
  def following
    @user = User.find(params[:user_id])
    @followings = @user.following_user
  end

  # 自分をフォローしているユーザー一覧
  def follower
    @user = User.find(params[:user_id])
    @followers = @user.follower_user
  end

  require 'net/https'
  require 'net/http'
  require 'uri'
  require 'json'

  def create_zoom
    @api_key = "66aoWxi3R1CCqYtfXXX3vA"
    @secret  = "eoEOrBqOAFBidWwGKmrB2HUHwb6YT8a6DRSV"
    @jwt = self.GenerateJWT
    @user_id = self.GetUserData(@jwt)
    @meeting_url = "https://api.zoom.us/v2/users/#{@user_id}/meetings"

    uri = URI.parse(@meeting_url)
    http = Net::HTTP.new(uri.host, uri.port)

    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.path)
    req["Authorization"] = "Bearer #{@jwt}"
    aa = "Bearer #{@jwt}"
    puts aa
    req["Content-Type"] = "application/json"
    req.body = {
        "type":1,
        }.to_json
    res = http.request(req)
    parseURL = JSON.parse(res.body)
    @url = parseURL["join_url"]
    @host_url = parseURL["start_url"]
  end

  def GenerateJWT
    payload = { 
        iss: @api_key,
        exp: Time.now.to_i + 4 * 36000
    }
    token = JWT.encode payload, @secret, 'HS256'
    return token
  end

  def GetUserData(_token)
    uri = URI.parse("https://api.zoom.us/v2/users")
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer "+_token
    req_options = {
        use_ssl: uri.scheme == "https",
    }
    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
        http.request(request)
    end
    result = JSON.parse(response.body)
    return result["users"][0]["id"].to_s
  end

  private
  def user_params
    params.require(:user).permit(:name,:gender,:grade,:faculty, :twitter_url)
  end
end
