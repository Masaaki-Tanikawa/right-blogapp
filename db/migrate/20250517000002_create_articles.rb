class CreateArticles < ActiveRecord::Migration[7.2]
  def change
    create_table :articles do |t|
      t.references :user, null: false, foreign_key: true # articlesテーブルをuserと紐づけ、UserIDに値がないと保存できなくする
      t.string :title, null: false # データ型：カラム名,stringは短い文字列＋値がないと保存できなくする
      t.text :content, null: false# textは長い文字列＋値がないと保存できなくする
      t.timestamps # 作成日を保存（デフォルト）
    end
  end
end
