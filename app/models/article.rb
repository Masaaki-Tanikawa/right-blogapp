# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  content    :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Article < ApplicationRecord
  validates :title, presence: true # presence: trueで入力を必須にする
  validates :content, presence: true

  def display_created_at
    I18n.l(self.created_at, format: :default) # 日付表示における冗長な部分を共通化
  end
end
