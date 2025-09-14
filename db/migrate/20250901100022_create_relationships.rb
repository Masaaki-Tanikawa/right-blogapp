class CreateRelationships < ActiveRecord::Migration[7.2]
  def change
    create_table :relationships do |t|
      t.references :follower, null: false, foreign_key: { to_table: :users }  # 外部キーでusersテーブルと関連付け・データを取得
      t.references :followed, null: false, foreign_key: { to_table: :users }
      t.timestamps
    end
  end
end
