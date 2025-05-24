# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :articles, dependent: :destroy # 1つのユーザーに対して複数の記事を紐づける(ユーザーが削除されたら記事も削除)
  has_one :profile, dependent: :destroy # 1つのユーザーに対して1つのプロフィールを紐づける(ユーザーが削除されたら記事も削除)
  has_many :likes, dependent: :destroy # 1つのユーザーに対して複数のいいねを紐づける(ユーザーが削除されたらいいねも削除)

  # アカウントIDを表示する値をつくる
  def display_name
    profile&.nickname || self.email.split('@').first # Profileのnicknameを取得。nicknameがない・Profileが存在しない場合は、メールアドレスの@以前を取得
    # オブジェクト&.メソッド:ぼっち演算子 => オブジェクトが存在しない(nil)の時はメソッドを実行しない
  end

  delegate :birthday, :age, :gender, :introduction, to: :profile, allow_nil: true
  # ※delegateメソッドで以下の処理をまとめて実行
  # def birthday
  #   profile&.birthday
  # end
  # def gender
  #   profile&.gender
  # end
  # def introduction
  #   profile&.introduction
  # end

  # プロフィール情報の有無で、情報を呼び出すか・空の箱を作るかを使い分ける
  def prepare_profile
    profile || build_profile
  end
  # 画像アップロードの有無で、アップロード画像・デフォルト画像どちらかを表示するかを使い分ける
  def avatar_image
    if profile&.avatar&.attached? # 条件は、プロフィール・アバター両方が存在している状態でアップロードされていること
      profile.avatar
    else
      'default-avatar.png'
    end
  end
end
