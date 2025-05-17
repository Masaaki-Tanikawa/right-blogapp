# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# ダミーデータを作成する
Article.create({ title: 'タイトル1', content: 'コンテンツ1' })
Article.create({ title: 'タイトル2', content: 'コンテンツ2' })

# ダミーデータをfakerで作成する
10.times do # 10記事作成
Article.create(
  title: Faker::Lorem.sentence(word_count: 5), # タイトルは5文字
  content: Faker::Lorem.sentence(word_count: 100) # 本文は100文字
)
end
