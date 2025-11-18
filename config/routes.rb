require 'sidekiq/web' # SidekiqのUI画面をRailsに読み込む

Rails.application.routes.draw do
  # 開発環境のみ../letter_openerでletter_openerの内容を確認できるようにする
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
	# SidekiqのUI画面でjoqやqueuesの状況を確認できるようにする
	mount Sidekiq::Web => '/sidekiq' if Rails.env.development?

  devise_for :users
  # 記事一覧だとわかるようにテーブル名をarticlesとする
  root to: 'articles#index'
  # articlesのURLを作成する(全てのアクションが有効)
  resources :articles do
    resources :comments, only: [ :index, :new, :create ] # articles/commentsのURLを作成＋コメント一覧ページを追加
    resource :like, only: [:create, :destroy, :show] # 記事に対していいねする：いいねの情報は記事に一つのためresourceを使用。※createでいいねをつけてdestroyでいいねを解除＋showでいいねのステータス管理
  end

  resource :profile, only: [:show, :edit, :update] # profileのURLを作成: プロフィールの情報は一つのためresource、Likesテーブルにレコードを作るためcreateをそれぞれ使用

  resources :favorites, only: [:index] # いいねした記事一覧ページ /favoritesのURLを作成

  resources :accounts, only: [:show ] do # 各ユーザのプロフィールが見れるページ /accountsのURLを作成
    resources :follows, only: [:create ] # followの関係をcreateで作り、フォローできるようにする
    resources :unfollows, only: [:create ] # unfollowの関係をcreateで作り、フォローを解除できるようにする
  end

  resource :timeline, only: [:show]# タイムラインはユーザーにとって1つしかないためresource・一覧を表示させるだけのためonly: [:show]
end
