class UsersAdminNotNullDefaultFalse < ActiveRecord::Migration[7.2]
  def change
    change_column_null :users, :admin, false
  end
end
