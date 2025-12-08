class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern #開発環境のみ無効化:検証ツール使用時の406エラー防止

  # 全てのアクションを実行する前に、設定言語を変更する処理：set_localeを実行
  before_action :set_locale
  # ActiveDecoratorをdeviseで有効にする
  def current_user
    ActiveDecorator::Decorator.instance.decorate(super) if super.present?
    super
  end

  # http://localhost:3000/?locale=ja をデフォルトのURLに設定する
  def default_url_options
    { locale: I18n.locale }
  end

  private
  def set_locale
    # パラメータの値を取得して言語を設定する (http://localhost:3000/?locale=en を入力 => 言語設定を英語に変更)
    I18n.locale = params[:locale] || I18n.default_locale # パラメータの値がない場合はデフォルトの値:ja(config/application.rb => config.i18n.default_locale)を設定
  end
end
