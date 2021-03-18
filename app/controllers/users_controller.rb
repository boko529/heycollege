class UsersController < ApplicationController   
  before_action :authenticate_user!, only: [:edit,:update,:show,:following,:follower, :hide]
  before_action :user_is_not_deleted_show, only: [:show]
  before_action :user_is_not_deleted_follow, only: [:following, :follower]
  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews.includes(lecture: :teacher).page(params[:reviews_page]).per(10)
    @lectures = @user.lectures.includes(:reviews, :teacher).page(params[:lectures_page]).per(20)
    @groups = @user.group
    if @user.twitter_name.present? && @user.instagram_name.present?
      @twitter = "https://twitter.com/"+@user.twitter_name
      @instagram = "https://instagram.com/"+@user.instagram_name
    elsif @user.twitter_name.present?
      @twitter = "https://twitter.com/"+@user.twitter_name
    elsif @user.instagram_name.present?
      @instagram = "https://instagram.com/"+@user.instagram_name
    end
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

  # 退会(論理削除)
  def hide
    @user = User.find(params[:id])
    @user.update(is_deleted: true)
    reset_session
    flash[:notice] = "ありがとうございました。またのご利用を心からお待ちしております。"
    redirect_to root_path
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
    params.require(:user).permit(:name,:gender,:grade,:faculty, :twitter_name, :instagram_name, :message)
  end

  # 退会しているかを確認(user/show用)
  def user_is_not_deleted_show
    @user = User.find(params[:id])
    if @user.is_deleted
      flash[:notice] = "退会済みユーザーです"
      redirect_to root_path
    end
  end

  # 退会しているかを確認(フォローフォロワーリスト用)idの種類が違うので分けている
  def user_is_not_deleted_follow
    @user = User.find(params[:user_id])
    if @user.is_deleted
      flash[:notice] = "退会済みユーザーです"
      redirect_to root_path
    end
  end
end
