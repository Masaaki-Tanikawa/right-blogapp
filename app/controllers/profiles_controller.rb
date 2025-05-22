class ProfilesController < ApplicationController
  before_action :authenticate_user! # ログインしていないと実行できないようにする
  def show
    @profile = current_user.profile # profileの値を取得する（profile:user.rbで紐付けた値）
  end

  def edit
  end
end