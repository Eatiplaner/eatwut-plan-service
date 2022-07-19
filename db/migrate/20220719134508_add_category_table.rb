class AddCategoryTable < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, null: false, index: { unique: true }
      t.references :parent_category, foreign_key: { to_table: :categories }

      t.timestamps
    end
  end
end
