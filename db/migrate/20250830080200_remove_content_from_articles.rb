class RemoveContentFromArticles < ActiveRecord::Migration[7.2]
  def change
    remove_column :articles, :content, :text # ロールバックできるように型も指定する
  end

	# または、upとdownでイミグレーション・ロールバックの動作を別途設定できる
  # def up
  #   remove_column :articles, :content
  # end
  # def down
  #   remove_column :articles, :content, :text
  # end

end
