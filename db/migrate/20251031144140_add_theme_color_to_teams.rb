class AddThemeColorToTeams < ActiveRecord::Migration[8.0]
  def change
    add_column :teams, :theme_color, :string
  end
end
