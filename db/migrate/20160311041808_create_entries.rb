class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :feed_id, null: false, default: 0
      t.integer :category, default: 0, limit: 1
      t.text :title, null: false
      t.string :url, null: false, default: ""
      t.string :author
      t.text :content
      t.string :digest
      t.string :guid
      t.datetime :published_at, null: false
      t.timestamps null: false
    end

    add_index :entries, [:feed_id, :guid], unique: true
    add_index :entries, :digest
  end
end
