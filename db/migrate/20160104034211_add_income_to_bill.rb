class AddIncomeToBill < ActiveRecord::Migration
  def change
    add_column :bills, :income, :integer
  end
end
