class AddAminUser < ActiveRecord::Migration[7.2]
  def up
    User.find_or_create_by!(email: 'mr.chalcev@bk.ru') do |user|
      user.name = 'Chalcev Ilya'
      user.admin = true
    end
  end

  def down
    user = User.find_by(email: 'mr.chalcev@bk.ru')
    user&.destroy
  end
end
