# articleモデルのtitleとcontentに値を入れてダミーデータを作る
FactoryBot.define do
  factory :article do
    title { Faker::Lorem.characters(number: 10) }
    content { Faker::Lorem.characters(number: 300) }
  end
end