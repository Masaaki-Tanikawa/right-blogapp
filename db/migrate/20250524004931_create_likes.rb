class CreateLikes < ActiveRecord::Migration[7.2]
  def change
    create_table :likes do |t|
      # Likeテーブルをarticles,articleと紐づけ、値がないと保存できなくする
      t.references :user, null: false
      t.references :article, null: false
      t.timestamps
    end
  end
end
