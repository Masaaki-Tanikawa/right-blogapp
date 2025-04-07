class ArticlesController < ApplicationController
  def index
    @article = Article.first # Articleモデルの最初の記事を取得して@articleに代入(インスタンス化)する
  end
end