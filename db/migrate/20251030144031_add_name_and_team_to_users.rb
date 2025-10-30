class AddNameAndTeamToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string
    add_reference :users, :team, null: false, foreign_key: true
  end
end
