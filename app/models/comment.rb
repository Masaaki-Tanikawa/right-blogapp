# == Schema Information
#
# Table name: comments
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  article_id :integer          not null
#
# Indexes
#
#  index_comments_on_article_id  (article_id)
#
# Foreign Keys
#
#  article_id  (article_id => articles.id)
#
class Comment < ApplicationRecord
  belongs_to :article  # コメントを1つの記事に紐づける
  validates :content, presence: true # content:本文を必須とする
end
