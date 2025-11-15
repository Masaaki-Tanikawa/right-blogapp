class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com' # "from@example.com"からメールを送信される
  layout 'mailer' # app/views/layouts/mailer.html.haml(HTMLメール)またはmailer.text.haml(テキストメール)を使用
end
