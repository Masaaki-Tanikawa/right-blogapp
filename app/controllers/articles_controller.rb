class ArticlesController < ApplicationController
  def index
    @articles = Article.all # Articleモデルのすべての記事を取得して@articles(複数取得するため@articleから変更)に代入(インスタンス化)する
  end

	def show
		@article = Article.find(params[:id]) #Articleのidを取得する
	end

	def new
		@article = Article.new #空のArticleインスタンスを作成する
	end

	def create
		@article = Article.new(article_params) #@article(new.html.erb)に、article_paramsの情報を保存するための箱を作る
		if @article.save #データベースに値を保存する
			redirect_to article_path(@article), notice: '保存できました' #記事詳細ページにジャンプする（「保存できました」と表示）
		else
			flash.now[:error] = '保存に失敗しました'
			render :new, status: :unprocessable_entity #@article(:title, :content)のデータを保存した状態で、new.html.erbを表示
		end
	end

def edit
	@article = Article.find(params[:id])
end

def update
	@article = Article.find(params[:id])
	if @article.update(article_params)
		redirect_to article_path(@article), notice: '更新できました' #対象idの要素(titleと:content)を更新できたら、対象idの記事ページに移動
	else
		flash.now[:error] = '更新に失敗しました'
		render :edit, status: :unprocessable_entity #更新に失敗したら、対象idの編集ページに移動
	end
end

	private #Strong Parameterを書くときに入力
	def article_params
		params.require(:article).permit(:title, :content) #フォームから投稿されたデータより、:titleと:contentの情報を抜き取る
		# params:Strong Parameterのひとつで、データを変更されても保存しないようにする。:titleと:contentだけ保存を許可
	end
end