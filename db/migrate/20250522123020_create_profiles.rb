class CreateProfiles < ActiveRecord::Migration[7.2]
  def change
    create_table :profiles do |t|
			t.references :user, null: false # Profileテーブルをuserと紐づけ、記事がないと保存できなくする
      t.string :nickname
      t.text :introduction
      t.integer :gender
      t.date :birthday
      t.boolean :subscribed, default: false # メールの受信設定、デフォルトはOFF
    end
  end
end
