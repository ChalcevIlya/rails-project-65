class MakeVasilisaAdmin < ActiveRecord::Migration[7.2]
  def up
    User.where(email: "vasiliqa13@gmail.com").update_all(admin: true)
  end

  def down
    User.where(email: "vasiliqa13@gmail.com").update_all(admin: false)
  end
end
