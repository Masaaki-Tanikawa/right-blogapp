class AccountsController < ApplicationController
  def show
    @user = User.find(params[:id]) # showアクションでユーザーのアカウント情報を取得
    if @user == current_user # 現在のユーザーが自身のアカウントページにアクセスしたらプロフィールページに遷移
      redirect_to profile_path
    end
  end
end