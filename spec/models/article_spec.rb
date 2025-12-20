require 'rails_helper'

RSpec.describe Article, type: :model do
  # letでダミーユーザーを変数として定義する
  let!(:user) do
    # ダミーユーザーを作成
    user = User.create!({
      email: 'test@example.com',
      password: 'password'
    })
  end

  # contextで条件を指定する
  context 'タイトルと内容が入力されている場合' do
    let!(:article) do
      user.articles.build({
        # 有効なダミー記事を作成
        title: Faker::Lorem.characters(number: 10),
        content: Faker::Lorem.characters(number: 300)
      })
    end
  # itでテストを実行する
  it '記事を保存できる' do
      # 記事が保存可能であることを確認
      expect(article).to be_valid
    end
  end

  # バリデーションで保存が失敗する条件もテストする
  context 'タイトルの文字が一文字の場合' do
    let!(:article) do
      # 無効なダミー記事を作成
      user.articles.create({ # エラーメッセージを取得するため、createで記事を作成
        title: Faker::Lorem.characters(number: 1),
        content: Faker::Lorem.characters(number: 300)
      })
    end
    it '記事を保存できない' do
      # titleのエラーメッセージ配列の先頭が、「は2文字以上で入力してください」と一致していることを確認
      expect(article.errors.messages[:title][0]).to eq('は2文字以上で入力してください')
    end
  end
end
