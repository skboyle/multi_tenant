class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description
      t.integer :priority, default: 0
      t.boolean :completed, default: false
      t.references :team, null: false, foreign_key: true
      t.references :project_leader, foreign_key: { to_table: :users }
      t.integer :order_position

      t.timestamps
    end
  end
end
