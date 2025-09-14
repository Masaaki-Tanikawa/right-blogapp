class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern #開発環境のみ無効化:検証ツール使用時の406エラー防止

  # ActiveDecoratorをdeviseで有効にする
  def current_user
    ActiveDecorator::Decorator.instance.decorate(super) if super.present?
    super
  end
end
