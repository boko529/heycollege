class Admin::AutoCreatesController < ApplicationController
  before_action :authenticate_user!
  before_action :if_not_admin
  before_action :need_password, only: [:create]
  
  def new
    @auto_creates = AutoCreate.all
    @auto_create = AutoCreate.new
    # 3/28のレビュー移行のためだけのやつ(new.html.erbにも外灯あり)
    @reviews = Review.all
    respond_to do |format|
      format.html
      format.csv do |csv|
        send_reviews_csv(@reviews)
      end
    end

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

  # 3/28の移行用
  def send_reviews_csv(reviews)
    bom = "\uFEFF"
    csv_data = CSV.generate(bom) do |csv|
      header = %w(review_id content past_lecture_id lecture_name teacher_name)
      csv << header

      reviews.each do |review|
        values = [review.id,review.content,review.lecture_id,review.lecture.name_ja,review.lecture.teacher.name_ja]
        csv << values
      end
    end
    send_data(csv_data, filename: "レビュー引き継ぎ.csv")
  end
  
  private
  def if_not_admin
    redirect_to root_path unless current_user.admin?
  end

  def auto_create_params
    params.require(:auto_create).permit(:name, :password, :university, :file)
  end

  # 自動作成にはパスワードが必要(ヒューマンエラー対策)
  def need_password
    unless auto_create_params[:password] == ENV['AUTO_CREATE_PASSWORD']
      flash[:danger] = "passwordを入力してください"
      redirect_to new_admin_auto_create_path
    end
  end
end
