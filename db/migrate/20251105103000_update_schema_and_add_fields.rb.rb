class UpdateSchemaAndAddFields < ActiveRecord::Migration[8.0]
  def change
    # Fix join table (projects_users)
    # Clean up extra columns added accidentally in previous migrations
    safety_assured do
      if column_exists?(:projects_users, :projects_id)
        remove_column :projects_users, :projects_id, :bigint
      end

      if column_exists?(:projects_users, :users_id)
        remove_column :projects_users, :users_id, :bigint
      end
    end

    # Add composite unique index for proper join table behavior
    add_index :projects_users, [ :project_id, :user_id ], unique: true unless index_exists?(:projects_users, [ :project_id, :user_id ])

    # Add new fields to users
    change_table :users, bulk: true do |t|
      t.bigint :invited_by_id, index: true
      t.string :title
      t.datetime :last_sign_in_at
      t.datetime :deactivated_at
    end

    add_foreign_key :users, :users, column: :invited_by_id

    # Add new fields to teams
    change_table :teams, bulk: true do |t|
      t.text :description
      t.bigint :owner_id, index: true
    end

    add_foreign_key :teams, :users, column: :owner_id

    # Add new fields to projects
    change_table :projects, bulk: true do |t|
      t.datetime :due_date
      t.boolean :archived, default: false, null: false
      t.string :color
    end

    # Add new fields to tasks
    change_table :tasks, bulk: true do |t|
      t.datetime :due_date
      t.bigint :assignee_id, index: true
      t.boolean :archived, default: false, null: false
    end

    add_foreign_key :tasks, :users, column: :assignee_id
  end
end
