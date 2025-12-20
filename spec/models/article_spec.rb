require 'rails_helper'

RSpec.describe Article, type: :model do
  # letでダミーユーザーを変数として定義する
  let!(:user) { create(:user) } # spec/factories/users.rbに登録されている:userを指定
    # ※メールアドレスの値を指定したいときは{ create(:user, email: 'test@test.com') }

    # contextで条件を指定する
    context 'タイトルと内容が入力されている場合' do
    let!(:article) { build(:article, user: user) } # spec/factories/articles.rbに登録されている:articleを指定＋:userに紐づいていることを指定

    # itでテストを実行する
    it '記事を保存できる' do
      # 記事が保存可能であることを確認
      expect(article).to be_valid
    end
  end

  # バリデーションで保存が失敗する条件もテストする
  context 'タイトルの文字が一文字の場合' do
    let!(:article) { build(:article, title: Faker::Lorem.characters(number: 1), user: user) } # タイトルの文字数を1文字にする

    # 記事のDB保存を試みる
    before do
      article.save
    end

    it '記事を保存できない' do
      # titleのエラーメッセージ配列の先頭が、「は2文字以上で入力してください」と一致していることを確認
      expect(article.errors.messages[:title][0]).to eq('は2文字以上で入力してください')
    end
  end
end
