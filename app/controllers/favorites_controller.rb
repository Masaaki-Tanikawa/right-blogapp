class FavoritesController < ApplicationController
  before_action :authenticate_user! # ログインしていないと実行できないようにする

  def index
    @articles = current_user.favorite_articles # 現在ログインしたユーザーがいいねした記事を全て取得
  end

end