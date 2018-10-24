class AddVersionToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :version, :integer, null: false, default: 1
  end
end
