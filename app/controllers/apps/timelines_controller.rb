# app/controllers/timelines_controller.rb → app/controllers/apps/timelines_controller.rb
class Apps::TimelinesController < Apps::ApplicationController
  # before_actionを削除
  def show
    user_ids = current_user.followings.pluck(:id) # pluckでfollowingsの取得できたレコードのIDを全て取得
    @articles = Article.where(user_id: user_ids) # pluckで取得したユーザーIDが含まれている記事を全て取得
  end

end