class AddIndexToLinks < ActiveRecord::Migration
  def change
    add_index :links, :source_id
  end
end
