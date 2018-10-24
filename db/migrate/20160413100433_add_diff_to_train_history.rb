class AddDiffToTrainHistory < ActiveRecord::Migration
  def change
    add_column :train_histories, :train_master_id, :integer
    add_index :train_histories, :train_master_id
  end
end
