# frozen_string_literal: true

module UserDecorator
  # app/models/user.rbのうち、viewに関する処理を移動

  # アカウントIDを表示する値をつくる
  def display_name
    profile&.nickname || self.email.split('@').first # Profileのnicknameを取得。nicknameがない・Profileが存在しない場合は、メールアドレスの@以前を取得
    # オブジェクト&.メソッド:ぼっち演算子 => オブジェクトが存在しない(nil)の時はメソッドを実行しない
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
