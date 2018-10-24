class AddTaglistToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :tag_list, :text
  end
end
