# Helperにview用のメソッドを定義する
# 現在のページのパスに合わせて、activeクラスを付与する
module TabsHelper
  def add_active_class(path)
    path = path.split('?').first # ?以降のパスを除去 (http://localhost:3000/?locale=XX でタブにactiveクラスがつくようにする)
    'active' if current_page?(path)
  end
end
