# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
class Article < ApplicationRecord
  validates :title, presence: true # presence: trueで入力を必須にする
  validates :title, length: { minimum: 2, maximum: 100 } # length: で文字の長さを指定する
  validates :title, format: { with: /\A(?!\@)/ } # format: で先頭に@をつけることを禁止する

  validates :content, presence: true
  # validates :content, length: { minimum: 10 }
  # validates :content, uniqueness: true	# uniqueness: で値を一意（ユニーク）に指定する(uniquenessはSNSアカウント・メールアドレスでも使用)

  has_many :comments, dependent: :destroy # 1つの記事に対して複数のコメントを紐づける(記事が削除されたらコメントも削除)
  belongs_to :user # articleを1つのユーザーに紐づける
  has_many :likes, dependent: :destroy # 1つの記事に対して複数のいいねを紐づける(記事が削除されたらいいねも削除)
  has_one_attached :eyecatch # アイキャッチ画像を（1つ）アップロード
  has_rich_text :content # contentの値をエディタで強化して保存(その後、既存のcontentを削除)


  # validate :validate_title_and_content_length # validateで、独自のルールを作る
  # private
  # def validate_title_and_content_length # タイトルと内容の合計は100文字未満の場合、エラーとする
  #   char_count = self.title.length + self.content.length
  #   errors.add(:content, 'タイトルと内容の合計は100文字以上にしてください') unless char_count > 100
  # end
end
