class CreateTrainMasters < ActiveRecord::Migration
  def change
    create_table :train_masters do |t|
      t.integer :mean, default: 0, null: false
      t.text :content_json
      t.datetime :trained_at

      t.timestamps null: false
    end
  end
end
