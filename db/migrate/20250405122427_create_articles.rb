class CreateArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :articles do |t|
      t.string :title # データ型：カラム名,stringは短い文字列
      t.text :content # textは長い文字列
      t.timestamps # 作成日を保存（デフォルト）
    end
  end
end
