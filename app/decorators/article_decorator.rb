# frozen_string_literal: true

module ArticleDecorator
  # app/models/article.rbのうち、viewに関する処理を移動

  def display_created_at
    I18n.l(self.created_at, format: :default) # 日付表示における冗長な部分を共通化
  end

  def like_count # 記事のいいねをカウントする
    likes.count
  end
end
