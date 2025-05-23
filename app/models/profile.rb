# == Schema Information
#
# Table name: profiles
#
#  id           :integer          not null, primary key
#  birthday     :date
#  gender       :integer
#  introduction :text
#  nickname     :string
#  subscribed   :boolean          default(FALSE)
#  user_id      :integer          not null
#
# Indexes
#
#  index_profiles_on_user_id  (user_id)
#
class Profile < ApplicationRecord
  enum gender: { male: 0 , female: 1, other: 2 } # セレクトボックスの値を定義
  belongs_to :user # プロフィールをユーザーに従属させる

  # 年齢の値を取得
  def age
    return '不明' unless birthday.present? # birthdayが入力されていないときは「不明」と表示
    years = Time.zone.now.year - birthday.year # 現在の年 - 誕生年 をyearと定義
    days = Time.zone.now.yday - birthday.yday # yday:1/1からどれだけ日付が経ったかを表示
    # 年齢の計算値を"~歳"で返す
    if days < 0
      "#{years - 1}歳"
    else
      "#{years}歳"
    end
  end
end
