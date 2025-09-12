Rails.application.routes.draw do
  devise_for :users
  # 記事一覧だとわかるようにテーブル名をarticlesとする
  root to: 'articles#index'
  # articlesのURLを作成する(全てのアクションが有効)
  resources :articles do
    resources :comments, only: [ :new, :create ] # articles/commentsのURLを作成(コメント投稿ページを追加するのみのため、new・createアクションに限定)
    resource :like, only: [:create, :destroy ] # 記事に対していいねする：いいねの情報は記事に一つのためresourceを使用。※createでいいねをつけてdestroyでいいねを解除
  end

  resource :profile, only: [:show, :edit, :update] # profileのURLを作成: プロフィールの情報は一つのためresource、Likesテーブルにレコードを作るためcreateをそれぞれ使用

  resources :favorites, only: [:index] # いいねした記事一覧ページ /favoritesのURLを作成

  resources :accounts, only: [:show ] do # 各ユーザのプロフィールが見れるページ /accountsのURLを作成
    resources :follows, only: [:create ] # followの関係をcreateで作り、フォローできるようにする
    resources :unfollows, only: [:create ] # unfollowの関係をcreateで作り、フォローを解除できるようにする
  end

end
