require 'rails_helper'

RSpec.describe 'Api::Comments', type: :request do
  # コメントを作成する
  let!(:user) { create(:user) } # ダミーユーザーを作成
  let!(:article) { create(:article, user: user) } # ダミー記事を作成
  let!(:comments) { create_list(:comment, 3, article: article) } # ダミーコメントを3つ作成

  # コメント一覧APIにアクセスしたときに、正しい内容のJSONが返るかのテストを作成
  describe 'GET /api/comments' do
    it '200 Status' do
      # 指定したarticleに紐づくコメント一覧にGETリクエストを送信する
      get api_comments_path(article_id: article.id)
      # API が 正常に処理される（200を返す）ことを確認
      expect(response).to have_http_status(200)

      body = JSON.parse(response.body) # JSON文字列を Rubyの配列 / ハッシュに変換
      # 3件のコメントが返ってくることを確認
      expect(body.length).to eq 3
      # JSONで返ってきたコメント内容が、DB上のcommentsとそれぞれ一致しているかを確認
      expect(body[0]['content']).to eq comments.first.content
      expect(body[1]['content']).to eq comments.second.content
      expect(body[2]['content']).to eq comments.third.content
    end
  end
end