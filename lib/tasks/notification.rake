namespace :notification do
  # rakeタスクの説明
  desc '利用者にメールを送付する'

  # rakeタスクを記入
  task :send_emails_from_admin, ['msg'] => :environment do |task, args| # 引数 msg をメール本文として利用する
    # Jobを実行 ※msgの内容を一斉送信・msgの値がない場合はエラーメッセージを表示
    msg = args['msg']
    if msg.present?
      NotificationFromAdminJob.perform_later(msg)
    else
      puts '送信できませんでした。メッセージを入力してくてださい。ex. rails notification:send_emails_from_admin\[こんにちは\]'
    end
  end
end
# => bundle exec rake notification:send_emails_from_admin["こんにちは"] を実行すると、メールの本文：こんにちはで一斉送信される