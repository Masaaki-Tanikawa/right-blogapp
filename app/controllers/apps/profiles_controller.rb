# app/controllers/profiles_controller.rb → app/controllers/apps/profiles_controller.rb
class Apps::ProfilesController < Apps::ApplicationController
  # before_actionを削除
  def show
    @profile = current_user.profile # profileの値を取得する（profile:user.rbで紐付けた値）
  end

  def edit
    @profile = current_user.prepare_profile # profileの値が存在したらそのまま表示、存在しない場合はプロフィールの内容を保存する空の箱を作る(has_oneの場合は,build_単数形のモデル名と入力)
    # prepare_profileアクションをapp/models/user.rbに設定することで、@profile = current_user.profile || current_user.build_profile を短縮
  end

  def update
    @profile = current_user.prepare_profile
    @profile.assign_attributes(profile_params) # プロフィールの情報を取得して保存(すでに入力されている場合は、その情報を取り込んで上書き)
    if @profile.save
      redirect_to profile_path, notice: 'プロフィール更新！'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  private
  def profile_params # 保存する対象を設定
    params.require(:profile).permit(
      :nickname,
      :introduction,
      :gender,
      :birthday,
      :subscribed,
      :avatar
    )
  end
end