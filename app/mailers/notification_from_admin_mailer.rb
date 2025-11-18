class NotificationFromAdminMailer < ApplicationMailer
  def notify(user, msg)
    @msg = msg # メッセージを引数にして、メッセージを送信できるようにする
    mail to: user.email, subject: 'お知らせ' # ユーザーのemail宛に件名：お知らせでメールを送信
  end
end