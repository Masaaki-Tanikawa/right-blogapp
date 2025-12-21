require 'rails_helper'

# ダブルクォーテーションをシングルクォーテーションに変更
RSpec.describe 'Articles', type: :request do
  # 記事を用意して、レスポンスがあることを確認する
  let!(:user) { create(:user) }  # ダミーユーザーを作成
  let!(:articles) { create_list(:article, 3, user: user) }  # ダミーユーザーを紐付けて、ダミー記事を3つ作成

  # ArticlesのindexにGETリクエストを送ったときに、正常にレスポンス（200 OK）が返るかのテストを作成
  describe 'GET /articles' do
    it '200ステータスが返ってくる' do
      # /articlesにHTTP GETリクエストを送る
      get articles_path
      # HTTPステータスが200であることを確認
      expect(response).to have_http_status(:ok) #
    end
  end

  # 記事が保存できるかのテストを作成
  describe 'POST /articles' do
    context 'ログインしている場合' do
      before do
        sign_in user # Deviseでログインする
      end
      it '記事が保存される' do
        # 記事作成用のパラメータを生成する
        article_params = attributes_for(:article) # FactoryBotのattributes_forで、リクエストで送る値（ハッシュ）を作る
        # articleのパラメータを付けて POST リクエストを送信する
        post articles_path({article: article_params})
        # 保存後にリダイレクトされるため、HTTPステータスが302であることを確認
        expect(response).to have_http_status(302)

        # 実際に保存されているかを確認する
        # ※ DBに保存された最新のタイトル・内容とパラメータのタイトル・内容が一致していることを確認
        expect(Article.last.title).to eq(article_params[:title])
        expect(Article.last.content.body.to_plain_text).to eq(article_params[:content]) # ActionTextとして保存されたcontentをプレーンテキストに変換
      end
    end
  end

  # 未ログインの場合は、ログイン画面に遷移するかのテストを作成
  context 'ログインしていない場合' do
    it 'ログイン画面に遷移する' do
      # articleのパラメータを生成して、POSTリクエストを送信する
      article_params = attributes_for(:article)
      post articles_path({article: article_params})
      # ログインのパスにリダイレクトされる
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
