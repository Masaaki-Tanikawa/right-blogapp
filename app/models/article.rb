# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  content    :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
class Article < ApplicationRecord
  validates :title, presence: true # presence: trueで入力を必須にする
  validates :title, length: { minimum: 2, maximum: 100 } # length: で文字の長さを指定する
  validates :title, format: { with: /\A(?!\@)/ } # format: で先頭に@をつけることを禁止する

  validates :content, presence: true
  validates :content, length: { minimum: 10 }
  validates :content, uniqueness: true	# uniqueness: で値を一意（ユニーク）に指定する(uniquenessはSNSアカウント・メールアドレスでも使用)

	belongs_to :user #articleを1つのユーザーに紐づける

  def display_created_at
    I18n.l(self.created_at, format: :default) # 日付表示における冗長な部分を共通化
  end

  validate :validate_title_and_content_length # validateで、独自のルールを作る
  private
  def validate_title_and_content_length # タイトルと内容の合計は100文字未満の場合、エラーとする
    char_count = self.title.length + self.content.length
    errors.add(:content, 'タイトルと内容の合計は100文字以上にしてください') unless char_count > 100
  end
end
