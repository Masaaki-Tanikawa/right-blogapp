# app/controllers/likes_controller.rb → app/controllers/api/likes_controller.rb
class Api::LikesController < Api::ApplicationController # namespace（名前空間）Api::をつけて、API専用コントローラであることを明示
  before_action :authenticate_user!

  def create # いいねをつける
    article = Article.find(params[:article_id]) # 記事のIDを取得
    article.likes.create!(user_id: current_user.id) # 取得した記事からいいねを作成（ユーザーIDはログインしているユーザーを指定）※ユーザーが入力しない・必ず保存されるため！をつける
    render json: { status: 'ok' } # 「記事URLに戻る」から「JSONデータ{ "status": "ok" }を返す」に変更
  end

	def destroy # いいねを消去する
    article = Article.find(params[:article_id])
    like = article.likes.find_by!(user_id: current_user.id) # 対象記事の中から、ログイン中のユーザーが実施したいいねを取得する ※ユーザーは必ず存在する・エラーが起こり得ないため！をつける
    like.destroy! # データを削除する
    render json: { status: 'ok' } # 「記事URLに戻る」から「JSONデータ{ "status": "ok" }を返す」に変更
  end

  # いいねしているかどうかをステータスとして管理する
  def show
    article = Article.find(params[:article_id]) # 記事のIDを取得
    like_status = current_user.has_liked?(article) # いいねしているかどうかを取得
    render json: { hasLiked: like_status } # いいねしているかどうかのデータをハッシュ(true/false)で返す (レスポンスがJSのためhasLiked)
    # http://localhost:3000/articles/XX/like にアクセスすると、{"hasLiked":true(false)}が表示される
  end
end