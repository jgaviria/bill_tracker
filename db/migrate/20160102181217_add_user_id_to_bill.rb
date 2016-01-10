class AddUserIdToBill < ActiveRecord::Migration
  def change
    add_column :bills, :user_id, :integer
  end
end
