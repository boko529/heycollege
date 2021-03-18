class ApplicationController < ActionController::Base
  before_action :set_search
  before_action :store_location, unless: :devise_controller? # デバイス関係のコントローラー以外のときにセッションを取る
  before_action :configure_permitted_parameters, if: :devise_controller?


  def set_search
    @q = Lecture.ransack(params[:q])
    @lectures = @q.result.page(params[:page])
  end

  # ログインページ以外のときはページのバスをセッションに保存する
  def store_location
    if request.path !=  new_user_session_path
      session[:previous_url] = request.fullpath 
    end
  end
  
  # セッションにページのパスが保存されている場合はそのページにリダイレクト
  def after_sign_in_path_for(resource)
    if !session[:previous_url].nil?
      session[:previous_url]
    else
      user_path(resource)
    end
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:faculty,:grade,:gender])
    end
end
