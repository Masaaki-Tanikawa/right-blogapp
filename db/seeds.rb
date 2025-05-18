# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# ダミーアカウントを作成する
john = User.find_or_create_by!(email: "john@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end
emily = User.find_or_create_by!(email: "emily@example.com") do |user|
  user.password = "password"
  user.password_confirmation = "password"
end
# find_or_create_by!でユーザーの重複作成を防止して、繰り返しdb:seedが実行できる


# ダミー記事を各アカウントで5つ作成する
5.times do
john.articles.create(
  title: Faker::Lorem.sentence(word_count: 5), # タイトルは5文字
  content: Faker::Lorem.sentence(word_count: 100) # 本文は100文字
)
end
5.times do
emily.articles.create(
  title: Faker::Lorem.sentence(word_count: 5), # タイトルは5文字
  content: Faker::Lorem.sentence(word_count: 100) # 本文は100文字
)
end
