# app/controllers/favorites_controller.rb → app/controllers/apps/favorites_controller.rb
class Apps::FavoritesController < Apps::ApplicationController
  # before_actionを削除
  def index
    @articles = current_user.favorite_articles # 現在ログインしたユーザーがいいねした記事を全て取得
  end

end