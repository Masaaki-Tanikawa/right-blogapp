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
  has_many :favorite_articles, through: :likes, source: :article # 中間テーブル:likesを通してArticleモデルを favorite_articles で取得。※source: :article:favorite_articlesはデータベースにないため、実際の関連先がarticleであることを明示

  has_many :following_relationships, foreign_key: 'follower_id', class_name: 'Relationship', dependent: :destroy  # 自分がフォローしている関係をつくる => Relationshipsテーブルの中で follower_id に自分のidが入っているレコードを集める
  has_many :followings, through: :following_relationships, source: :following  # 自分がフォローしているユーザーの一覧 => 中間テーブル:following_relationshipsを通してfollowing（相手ユーザー）の情報を取得
  has_many :follower_relationships, foreign_key: 'following_id', class_name: 'Relationship', dependent: :destroy  # 自分をフォローしている関係をつくる => Relationshipsテーブルの中で following_id に自分のidが入っているレコードを集める
  has_many :followers, through: :follower_relationships, source: :follower  # 自分をフォローしているユーザーの一覧 => 中間テーブル:follower_relationshipsを通してfollower（相手ユーザー）の情報を取得

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

  def has_liked?(article) # ユーザーが対象IDの記事に、いいねしているかどうかを判別する
    likes.exists?(article_id: article.id)
  end

  def follow!(user) # 指定したユーザーをフォローする (!で例外を発生させる)
    following_relationships.create!(following_id: user.id) # 新しいfollowing_relationshipsテーブルのレコードを作り、following_idにフォローした相手ユーザーのidを保存する(follower_idには自身のidが入る)
  end
  def unfollow!(user) # 指定したフォローを解除する
    relation = following_relationships.find_by!(following_id: user.id) # following_relationshipsテーブルから「自分(follower_id)が user(following_id) をフォローしている関係」を探す
    relation.destroy! # 見つかった関係（フォロー情報）を削除する
  end
end
