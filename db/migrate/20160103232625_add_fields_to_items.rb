class AddFieldsToItems < ActiveRecord::Migration
  def change
    add_column :items, :paid,      :integer
    add_column :items, :sub_total, :integer
  end
end
