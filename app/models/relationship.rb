# == Schema Information
#
# Table name: relationships
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  follower_id  :integer          not null
#  following_id :integer          not null
#
# Indexes
#
#  index_relationships_on_follower_id   (follower_id)
#  index_relationships_on_following_id  (following_id)
#
# Foreign Keys
#
#  follower_id   (follower_id => users.id)
#  following_id  (following_id => users.id)
#
class Relationship < ApplicationRecord
  belongs_to :follower, class_name: 'User' # follower_id を持つユーザー(フォローしている自身のユーザーID)に紐付け
  belongs_to :following, class_name: 'User' # following_id を持つユーザー(自身がフォローしている相手のユーザーID)に紐付け

  # フォローが実行(RelationshipモデルのレコードがDBに保存)された直後に、send_email メソッド(メールの送信)を実行する
  after_create :send_email # after_create:ActiveRecordのコールバック機能の一つ

  private
  def send_email
    # after_createで取得したRelationshipモデルの情報をもとに、new_followerメソッドを実行
    RelationshipMailer.new_follower(following, follower).deliver_now
  end
end
