# app/controllers/comments_controller.rb → app/controllers/api/comments_controller.rb
class Api::CommentsController < Api::ApplicationController # namespace（名前空間）Api::をつけて、API専用コントローラであることを明示
  def new # コメント入力フォームを表示する
    article = Article.find(params[:article_id]) # 対象となる記事をIDから取得
    @comment = article.comments.build # コメントの内容を保存する空の箱を作る
  end

  def index # コメントの内容をJSONで取得する
    article = Article.find(params[:article_id]) # 対象となる記事をIDから取得
    comments = article.comments # 対象となる記事のcomments取得
    render json: comments.as_json(only: [:id, :content]) # 「id」と「content」カラムを含んだJSONを出力(as_json で取得する属性を選択)
    # → http://localhost:3000/articles/XX/comments で 記事ごとのコメントID・内容がJSON形式で出力される
  end

  def create # コメントをDBに保存する
    article = Article.find(params[:article_id]) # 対象となる記事をIDから取得
    @comment = article.comments.build(comment_params) # コメントの本文を取得
    @comment.save! # コメントをデータベースに保存、失敗したら例外（エラー）を発生させる
    render json: @comment # 保存したコメントを JSON として返す
  end

  private
  def comment_params
    params.require(:comment).permit(:content) # commentの中のcontent(本文)しか保存しない
  end
end