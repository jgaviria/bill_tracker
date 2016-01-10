class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :item_name
      t.integer :amount

      t.timestamps null: false
    end
  end
end
