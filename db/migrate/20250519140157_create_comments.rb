class CreateComments < ActiveRecord::Migration[7.2]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true # Commentテーブルをarticlesと紐づけ、記事がないと保存できなくする
      t.text :content, null: false # textはコメント本文＋値がないと保存できなくする
      t.timestamps # 作成日を保存（デフォルト）
    end
  end
end
