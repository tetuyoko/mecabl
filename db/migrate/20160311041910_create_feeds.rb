class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.text :title, null: false
      t.string :url, null: false
      t.string :etag
      t.string :feed_url, null: false
      t.text :description, null: false
      t.datetime :modified_at

      t.timestamps null: false
    end
    add_index :feeds, :feed_url, unique: true
  end
end
