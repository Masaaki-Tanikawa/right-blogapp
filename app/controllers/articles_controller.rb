class ArticlesController < ApplicationController
  def index
    @articles = Article.all # Articleモデルのすべての記事を取得して@articles(複数取得するため@articleから変更)に代入(インスタンス化)する
  end
end