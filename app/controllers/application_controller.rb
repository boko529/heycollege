class ApplicationController < ActionController::Base
  before_action :set_search
  # before_action :store_location, unless: :devise_controller? # デバイス関係のコントローラー以外のときにセッションを取る
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :set_university_id, except: [:change_language, :change_university] # これがないとセッションに保存するアクションさせてもらえないw

  def set_search
    # ログインしてる時に大学によってモデルを変える
    if user_signed_in?
      if current_user.university_id == 1
        @q = Apu::Lecture.ransack(params[:q])
        @lectures = @q.result.page(params[:page])
      elsif current_user.university_id == 2
        @q = Opu::Lecture.ransack(params[:q])
        @lectures = @q.result.page(params[:page])
      end
    else
      if session[:university_id] == "1"
        @q = Apu::Lecture.ransack(params[:q])
        @lectures = @q.result.page(params[:page])
      elsif session[:university_id] == "2"
        @q = Opu::Lecture.ransack(params[:q])
        @lectures = @q.result.page(params[:page])
      end

    end
  end

  # ログインしないとほとんど見せないので不要になった
  # ログインページ,ハイボルテージ関係以外のときはページのバスをセッションに保存する
  # def store_location
  #   if request.path !=  new_user_session_path && request.path != page_path('explain_confirmation') && request.path != page_path('privacypolicy') && request.path != page_path('terms') && request.path != page_path('aboutus')
  #     session[:previous_url] = request.fullpath 
  #   end
  # end
  
  # フレンドリーフォワーディングを削除した関係で全てzoom一覧に飛ぶ
  # セッションにページのパスが保存されている場合はそのページにリダイレクト
  def after_sign_in_path_for(resource)
    if !session[:previous_url].nil?
      session[:previous_url]
    else
      # user_path(resource)
      zooms_path
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

  # 大学切り替え
  def change_university
    session[:university_id] = params[:university_id]
    redirect_to "/"
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

    # 大学を指定しているかの確認(指定していなかったら設定)
    def set_university_id
      unless session[:university_id] == '1' || session[:university_id] == '2' #大学が増えたらここも増やす
        # 大学設定ページに移動(ハイボルテージで作成)
        render page_path('set_university') #redirect_toだと何故かうまくいかん(pageの表示だけだから説)
      end
    end

    def d_university_id
      if user_signed_in?
        current_user.university_id
      elsif session[:university_id]
        session[:university_id].to_i # セッションがなかったらbeforeアクションで弾かれてるはず！！
      end
    end
end
