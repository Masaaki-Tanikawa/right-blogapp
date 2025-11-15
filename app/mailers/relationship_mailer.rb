class RelationshipMailer < ApplicationMailer # ApplicationMailerを継承
  # フォローされた時に通知メールを送るメソッドを定義（メソッドごとにviewが存在する）
  def new_follower(user,follower) #
    @user = user # フォローされたユーザー ※viewで使えるようにインスタンス定数を定義
    @follower = follower # フォローしたユーザー
    mail to: user.email, subject: '【お知らせ】フォローされました' # （フォロー通知を）送信するアドレスと件名を指定
  end
end