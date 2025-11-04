class AddRoleAndStatusToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :string, default: "member", null: false
    add_column :users, :status, :string, default: "pending", null: false
  end
end
