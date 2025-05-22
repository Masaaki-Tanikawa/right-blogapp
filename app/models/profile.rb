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
end
