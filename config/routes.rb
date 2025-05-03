Rails.application.routes.draw do
	#記事一覧だとわかるようにテーブル名をarticlesとする
	root to: 'articles#index'
	# articlesのURLを作成する(表示のみで使用)
	resources :articles, only: [:show]
end
