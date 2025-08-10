class BulletinsStateNotNullDefaultDraft < ActiveRecord::Migration[7.2]
  def change
    change_column_null :bulletins, :state, false
    change_column_default :bulletins, :state, from: nil, to: :draft
  end
end
