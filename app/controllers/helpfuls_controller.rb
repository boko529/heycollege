class HelpfulsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_review, only: [:create]
  before_action :set_lecture, only: [:create]
  before_action :not_helpful_me, only: [:create]
  
  def create
    helpful = Helpful.create(user_id: current_user.id, review_id: params[:review_id])
    helpful.save
    if helpful.review.user.group.none?{ |a| UserGroupRelation.find_by(user_id: current_user.id, group_id: a.id) } # レビュー書いたユーザーの所属団体に一度でも入ってたらポイントは発行されない(身内でポイントを稼ぐこと防止)(noneメソッドはeach文の用に機能して全てがfalseのときのみtrueになる。今回の場合はいいねしたユーザーが投稿者が入ってるグループに所属しているor所属したことがあるかを判定している)
      # 通知を発行
      helpful.create_notification_helpful!(current_user)
      # レビュー書き手に個人ポイントを発行
      helpful.review.user.helpfuled_point
      # レビュー書き手に団体ポイントを発行
      helpful.review.user.group_helpfuled_point
      # # 講義作成者に個人ポイントを発行
      # helpful.review.lecture.user.helpfuled_lecture_point
      # # 講義作成者に団体ポイントを発行
      # helpful.review.lecture.user.group_helpfuled_lecture_point
      # # 先生作成者に個人ポイントを発行
      # helpful.review.lecture.teacher.user.helpfuled_teacher_point
      # # 先生作成者に団体ポイントを発行
      # helpful.review.lecture.teacher.user.group_helpfuled_teacher_point
    else
      helpful.create_notification_helpful_not_point!(current_user) # ポイント付与なしだけどいいねされた通知
    end 
  end

  private
    def set_review
      @review = Review.find_by(id: params[:review_id])
    end

    def set_lecture
      @lecture = Lecture.find_by(id: params[:lecture_id])
    end

    def not_helpful_me
      if Review.find_by(id: params[:review_id]).user_id == current_user.id
        flash[:danger] = "自分のレビューに役に立ったはできません。"
        redirect_to lecture_path(@lecture)
      end
    end
end
