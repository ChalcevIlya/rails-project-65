class CategoryNameNotNull < ActiveRecord::Migration[7.2]
  def change
    change_column_null :categories, :name, false
    change_column_default :categories, :name, from: nil, to: 'DefaultCategoryName'
  end
end
