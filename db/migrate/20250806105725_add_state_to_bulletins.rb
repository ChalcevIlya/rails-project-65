class AddStateToBulletins < ActiveRecord::Migration[7.2]
  def change
    add_column :bulletins, :state, :string
  end
end
