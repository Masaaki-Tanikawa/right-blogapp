Rails.application.routes.draw do
	#記事一覧だとわかるようにテーブル名をarticlesとする
	root to: 'articles#index'
	# articlesのURLを作成する(表示・新規作成・保存・編集・更新のみで使用)
	resources :articles, only: [:show, :new, :create, :edit, :update]
end
