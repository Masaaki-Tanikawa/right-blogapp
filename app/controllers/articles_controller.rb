class ArticlesController < ApplicationController
  # before_action:actionの手前に処理を付け加える => show・edit・updateアクションの共通処理「@article = Article.find(params[:id])」をbefore_actionでまとめる
  before_action :set_article, only: [ :show, :edit, :update ] # show・edit・updateアクションの前に set_article メソッドを必ず実行する
  # DRY（Don’t Repeat Yourself）なコードを心がける！

	before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
	# 未ログイン状態で処理をできないようにする(ページの作成・更新・削除が対象)

  def index
    @articles = Article.all # Articleモデルのすべての記事を取得して@articles(複数取得するため@articleから変更)に代入(インスタンス化)する
  end

  def show # JavaScriptで一覧を表示させるため不要
  end

  def new
    @article = current_user.articles.build # 現在ログインしているユーザーのテーブルに記事を入れる箱を作る
  end

  def create
    @article = current_user.articles.build(article_params) # @article(new.html.erb)に、article_paramsの情報を保存するための箱を作る
    if @article.save # データベースに値を保存する
      redirect_to article_path(@article), notice: '保存できました' # 記事詳細ページにジャンプする（「保存できました」と表示）
    else
      flash.now[:error] = '保存に失敗しました'
      render :new, status: :unprocessable_entity # @article(:title, :content)のデータを保存した状態で、new.html.erbを表示
    end
  end

def edit
   @article = current_user.articles.find(params[:id]) # 現在ログインしているユーザーのArticlesテーブルから記事を探す(他のIDから記事を編集できないようにする)
end

def update
  @article = current_user.articles.find(params[:id]) # 現在ログインしているユーザーのArticlesテーブルから記事を探す(他のIDから記事を編集できないようにする)
  if @article.update(article_params)
    redirect_to article_path(@article), notice: '更新できました' # 対象idの要素(titleと:content)を更新できたら、対象idの記事ページに移動
  else
    flash.now[:error] = '更新に失敗しました'
    render :edit, status: :unprocessable_entity # 更新に失敗したら、対象idの編集ページに移動
  end
end

def destroy
  article =  current_user.articles.find(params[:id]) # 現在ログインしているユーザーのArticlesテーブルから記事を削除する(他IDから記事を削除できないようにする)
  article.destroy! # destroyで削除、!で削除できなかった際に処理を停止（削除されないとアプリ側の原因のため）
  redirect_to root_path, status: :see_other, notice: '削除に成功しました' # 「削除に成功しました」と表示させ、一覧ページに戻る
end

  private # Strong Parameterを書くときに入力
  def article_params
    params.require(:article).permit(:title, :content, :eyecatch) # フォームから投稿されたデータより、:titleと:contentと:eyecatchの情報を抜き取る
    # params:Strong Parameterのひとつで、データを変更されても保存しないようにする。:titleと:contentと:eyecatchだけ保存を許可
  end

  def set_article
    @article = Article.find(params[:id]) # show・edit・updateアクションの共通処理を入力
  end
end
