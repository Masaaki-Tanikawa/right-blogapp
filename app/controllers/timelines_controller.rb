class TimelinesController < ApplicationController
  before_action :authenticate_user! # 未ログイン状態では処理できないようにする

  def show
    user_ids = current_user.followings.pluck(:id) # pluckでfollowingsの取得できたレコードのIDを全て取得
    @articles = Article.where(user_id: user_ids) # pluckで取得したユーザーIDが含まれている記事を全て取得
  end

end