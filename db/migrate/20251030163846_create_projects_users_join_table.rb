class CreateProjectsUsersJoinTable < ActiveRecord::Migration[8.0]
  def change
    create_join_table :projects, :users do |t|
      t.references :projects, null: false, foreign_key: true
      t.references :users, null: false, foreign_key: true
    end
  end
end
