module NotificationsHelper
  # 確認していない通知があるかの確認
  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
