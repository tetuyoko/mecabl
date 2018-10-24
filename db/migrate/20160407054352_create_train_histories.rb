class CreateTrainHistories < ActiveRecord::Migration
  def change
    create_table :train_histories do |t|
      t.integer :entry_id, null: false
      t.integer :status, null:false, default: 0, limit: 1
      t.integer :category, null: false, default: 0, limit: 1

      t.datetime :trained_at
      t.timestamps null: false
    end
    add_index :train_histories, :entry_id
    add_index :train_histories, :category
  end
end
