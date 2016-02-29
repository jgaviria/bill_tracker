class AddArchiveToBills < ActiveRecord::Migration
  def change
    add_column :bills, :archive, :boolean
  end
end
