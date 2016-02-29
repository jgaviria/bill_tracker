class CreateArchivedBills < ActiveRecord::Migration
  def change
    create_table :archived_bills do |t|
      t.string :bill_name
      t.string :item_name
      t.integer :amount
      t.integer :paid
      t.integer :sub_total
      t.string :item_type

      t.timestamps null: false
    end
  end
end
