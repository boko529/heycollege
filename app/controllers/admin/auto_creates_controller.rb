class Admin::AutoCreatesController < ApplicationController
  before_action :authenticate_user!
  before_action :if_not_admin
  before_action :need_keyword, only: [:create]
  
  def new
    @auto_creates = AutoCreate.all
    @auto_create = AutoCreate.new
  end

  def create
    # トランザクションを使用することで処理の途中でエラーが出た場合は処理をロールバックする
    ActiveRecord::Base.transaction do
      @auto_create = AutoCreate.new(name: auto_create_params[:name])
      case auto_create_params[:university]
      when "1" then
        if @auto_create.valid?
          AutoCreate.import_APU(auto_create_params[:file])
          @auto_create.save!
          flash[:success] = "自動作成に成功しました"
          redirect_to new_admin_auto_create_path
        else
          flash[:danger] = "ログの作成に失敗しました"
          redirect_to new_admin_auto_create_path
        end
      when "2" then
        flash[:danger] = "大阪府立大学はまだ対応していません"
        redirect_to new_admin_auto_create_path
      else
        flash[:danger] = "大学を指定してください"
        redirect_to new_admin_auto_create_path
      end
    end
    end
  
  private
  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end

  def auto_create_params
    params.require(:auto_create).permit(:name, :keyword, :university, :file)
  end

  # 自動作成にはパスワードが必要(ヒューマンエラー対策)
  def need_keyword
    unless auto_create_params[:keyword] == "本当に追加"
      flash[:danger] = "確認キーワードを入力してください"
      redirect_to new_admin_auto_create_path
    end
  end
end
