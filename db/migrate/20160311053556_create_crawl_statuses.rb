class CreateCrawlStatuses < ActiveRecord::Migration
  def change
    create_table :crawl_statuses do |t|
      t.integer :feed_id, null:false, default: 0
      t.integer :status, null:false, default: 1
      t.integer :error_count, null:false, default: 0
      t.string :error_message
      t.string :http_status
      t.string :digest
      t.integer :update_fequency, null:false, default: 0
      t.datetime :crawled_at

      t.timestamps null: false
    end

    add_index :crawl_statuses, :feed_id
  end
end
