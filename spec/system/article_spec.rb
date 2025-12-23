# 記事の一覧が実際に正しく表示されているかのテスト
require 'rails_helper'

RSpec.describe 'Article', type: :system do

  # ダミーのユーザー・記事を作成
  let!(:user) { create(:user) }
  let!(:articles) { create_list(:article, 3, user: user) }

  it '記事一覧が表示される' do
    # visit(Capybaraの機能の一つ)で、root_path(TOPページ)をブラウザで開く
    visit root_path
    # 記事一覧ページに、各記事のタイトルが表示されていることを確認
    articles.each do |article|
      expect(page).to have_content(article.title)
    end
  end

  it '記事一覧からクリックして、記事詳細を表示できる' do
    visit root_path
    # 作成済みの記事のうち、最初の記事を取得する
    article = articles.first
    # click_on(Capybaraの機能の一つ)で、記事タイトルの文字列を持つリンク（aタグ）をクリックする
    click_on article.title
    # 遷移先のページに、article_titleクラス内に記事のタイトルが表示されていることを確認する
    expect(page).to have_css('.article_title', text: article.title)
    # 遷移先のページに、.article_contentクラス内に記事本文が表示されていることを確認する(リッチテキストをプレーンテキストに変換)
    expect(page).to have_css('.article_content', text: article.content.to_plain_text)
  end
end