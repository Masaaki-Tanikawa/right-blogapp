class UnfollowsController < ApplicationController
  before_action :authenticate_user! # 未ログイン状態ではフォローできないようにする(未ログインでfollowボタンを押したらログイン画面に遷移)

  def create # createアクションにリクエストが来たらフォローする
    current_user.unfollow!(params[:account_id]) # ログイン中のユーザーが所定のユーザーをフォロー解除する(user.rbの unfollowアクションを参照)
    redirect_to account_path(params[:account_id]) # フォローされたユーザーのアカウントページに遷移
  end
end