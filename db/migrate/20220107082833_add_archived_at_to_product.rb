class AddArchivedAtToProduct < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :archived_at, :datetime
  end
end
