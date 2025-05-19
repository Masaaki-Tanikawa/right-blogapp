class CommentsController < ApplicationController
  def new
    @comment = Article.find(params[:article_id]).comments.build # コメントの内容を保存する空の箱を作る
  end
end