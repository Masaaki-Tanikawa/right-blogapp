Rails.application.routes.draw do
  devise_for :users
  # 記事一覧だとわかるようにテーブル名をarticlesとする
  root to: 'articles#index'
  # articlesのURLを作成する(全てのアクションが有効)
  resources :articles do
    resources :comments, only: [ :new, :create ] # articles/commentsのURLを作成(コメント投稿ページを追加するのみのため、new・createアクションに限定)
  end

  resource :profile, only: [:show, :edit, :update] # profileのURLを作成: プロフィールのは情報は一つのため、resourceを使用(idの指定不要・indexなし)
end
