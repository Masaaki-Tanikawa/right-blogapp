Rails.application.routes.draw do
	#記事一覧だとわかるようにテーブル名をarticlesとする
	root to: 'articles#index'
end
