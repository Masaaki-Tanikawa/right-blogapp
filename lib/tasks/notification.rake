namespace :notification do
  # rakeタスクの説明
  desc '利用者にメールを送付する'

  # rakeタスクを記入
  task send_emails_from_admin: :environment do
    # Jobを実行 ※「rake task test」というメッセージを一斉送信
    NotificationFromAdminJob.perform_later('rake task test')
  end
end
