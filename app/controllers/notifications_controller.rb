class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.page(params[:page]).per(20)
    # 未確認だった通知に対して開いたら既読済みに変更
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end
end
