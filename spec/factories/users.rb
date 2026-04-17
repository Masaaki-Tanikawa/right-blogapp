# userモデルのemailとpasswordに値を入れてダミーデータを作る
FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'password' }
  end

  # userがビルドされたら、profileも自動的に作成
  trait :with_profile do
    after :build do |user|
      build(:profile, user: user)
    end
  end
end
