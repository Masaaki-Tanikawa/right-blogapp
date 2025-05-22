class ProfilesController < ApplicationController
  before_action :authenticate_user! # ログインしていないと実行できないようにする
  def show
    @profile = current_user.profile # profileの値を取得する（profile:user.rbで紐付けた値）
  end

  def edit
    @profile = current_user.build_profile  # プロフィールの内容を保存する空の箱を作る(has_oneの場合は,build_単数形のモデル名と入力)
  end
end