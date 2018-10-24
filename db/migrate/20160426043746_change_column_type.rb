class ChangeColumnType < ActiveRecord::Migration
  def up
    remove_columns :entries, :category
    add_column :entries, :category, :integer, limit: 1, null: false, default: 0
    add_column :entries, :thumb_url, :string 
    add_index :entries, :category
  end

  def down
    remove_column :entries, :category
    remove_column :entries, :thumb_url
    add_column :entries, :category, :string
  end
end
