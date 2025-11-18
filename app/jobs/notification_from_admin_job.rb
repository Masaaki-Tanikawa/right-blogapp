# 管理画面に登録されているユーザーにメールを一斉送信する
class NotificationFromAdminJob < ApplicationJob
  queue_as :default # defaultのqueueに入れる

  # jobをつくるときは、performメソッドを使用すること！
  def perform(msg) # メッセージを受け取ってperformメソッドを実行
    User.all.each do |user| # 管理画面に登録されている全てのユーザーを対象とする
      NotificationFromAdminMailer.notify(user, msg).deliver_later # メッセージ・メールの情報を取得して非同期で送信
    end
  end
end
# rails c => NotificationFromAdminJob.perform_later('メッセージが入ります') でメールの一斉送信を実行
# ※ perform_now:同期通信・perform_later:非同期通信
# ユーザー数合計＋1(NotificationFromAdminJob分)が、sidekiqにカウントされる