# frozen_string_literal: true

class Devises::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :guess_university, only: [:create] # 入力されたメアドで大学を指定
  before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    super
    # ユーザー新規登録時にメール認証関係する前にUserPointを作成してinitialポイント生成
    if user = User.find_by(id: resource.id)
      user.initial_point
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute, :type, :university_id])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    page_path('explain_confirmation')
  end

  # メールアドレスから大学を指定する
  def guess_university
    email = params[:user][:email]
    if email.include?("@apu.ac.jp")
      params[:user][:type] = "Apu::User"
      params[:user][:university_id] = 1
    elsif email.include?("@edu.osakafu-u.ac.jp")
      flash[:notice] = "大阪府立大学には近日対応予定です。"
      redirect_to  new_user_registration_path
      # params[:user][:type] = "Opu::User"
      # params[:user][:university_id] = 2
    else
      flash[:danger] = "アジア太平洋大学のメールアドレスを使用してください。"
      # flash[:danger] = "アジア太平洋大学または大阪府立大学のメールアドレスを使用してください。"
      redirect_to  new_user_registration_path
    end
  end
end
