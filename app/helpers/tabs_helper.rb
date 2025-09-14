# Helperにview用のメソッドを定義する
# 現在のページのパスに合わせて、activeクラスを付与する
module TabsHelper
  def add_active_class(path)
    'active' if current_page?(path)
  end
end
