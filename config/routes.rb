Rails.application.routes.draw do
  devise_for :users
  # 記事一覧だとわかるようにテーブル名をarticlesとする
  root to: 'articles#index'
  # articlesのURLを作成する(全てのアクションが有効)
  resources :articles
end
