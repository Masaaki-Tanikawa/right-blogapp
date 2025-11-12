class CommentsController < ApplicationController
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
    if @comment.save
      redirect_to article_path(article), notice: 'コメントを追加' # 'コメントを追加'を表示、記事詳細ページに戻る
    else
      flash.now[:error] = '更新できませんでした' # '更新できませんでした'を表示
      render :new # @commentのデータを保存した状態で、コメント作成フォームを再表示
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:content) # commentの中のcontent(本文)しか保存しない
  end
end