class AddLogoToTeams < ActiveRecord::Migration[8.0]
  def change
    add_column :teams, :logo, :string
  end
end
