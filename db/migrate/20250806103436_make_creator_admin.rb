class MakeCreatorAdmin < ActiveRecord::Migration[7.2]
  def change
    User.find_by(email: 'mr.chalcev@bk.ru')&.update!(admin: true)
  end
end
