class ApplicationController < ActionController::Base
  before_action :set_search
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  def set_search
    @q = Lecture.ransack(params[:q])
    @lectures = @q.result.page(params[:page])
  end

  def after_sign_in_path_for(resource)
    user_path(resource)
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
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name,:faculty,:grade,:gender])
    end
    # 言語切り替えようコード
    def set_locale
      if %w(ja en).include?(session[:locale])
        I18n.locale = session[:locale]
      end
    end
end
