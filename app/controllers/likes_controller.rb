class LikesController < ApplicationController
  before_action :authenticate_user!

  def create # いいねをつける
    article = Article.find(params[:article_id]) # 記事のIDを取得
    article.likes.create!(user_id: current_user.id) # 取得した記事からいいねを作成（ユーザーIDはログインしているユーザーを指定）※ユーザーが入力しない・必ず保存されるため！をつける
    redirect_to article_path(article) # 記事に戻る
  end

	def destroy # いいねを消去する
    article = Article.find(params[:article_id])
    like = article.likes.find_by!(user_id: current_user.id) # 対象記事の中から、ログイン中のユーザーが実施したいいねを取得する ※ユーザーは必ず存在する・エラーが起こり得ないため！をつける
    like.destroy! # データを削除する
    redirect_to article_path(article)
  end
end