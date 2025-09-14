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
end
