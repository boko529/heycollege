class ApplicationController < ActionController::Base
  before_action :set_search
  before_action :store_location, unless: :devise_controller? # デバイス関係のコントローラー以外のときにセッションを取る
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  def set_search
    @q = Lecture.ransack(params[:q])
    @lectures = @q.result.page(params[:page])
  end

  # ログインページ,ハイボルテージ関係以外のときはページのバスをセッションに保存する
  def store_location
    if request.path !=  new_user_session_path && request.path != page_path('explain_confirmation') && request.path != page_path('privacypolicy') && request.path != page_path('terms')
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

  #言語切り替えようアクション
  def change_language
    session[:locale] = params[:language]
    redirect_back(fallback_location: "/")
  end

  protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:faculty,:grade,:gender, :agreement]) # agreementは利用規約とプラバシーポリシーへの同意
    end
    # 言語切り替えようコード
    def set_locale
      if %w(ja en).include?(session[:locale])
        I18n.locale = session[:locale]
      end
    end
end
