class ApplicationController < ActionController::Base
  before_action :set_search, :configure_permitted_parameters, if: :devise_controller?

  def set_search
    @q = Lecture.ransack(params[:q])
    @lectures = @q.result.page(params[:page])
  end

  protected
    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end
end
