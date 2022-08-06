class AddEatPlanTable < ActiveRecord::Migration[7.0]
  def change
    create_table :eat_plans do |t|
      t.string :name, null: false, index: true
      t.string :description
      t.string :status
      t.string :duration_metric
      t.integer :duration_value
      t.integer :meals_per_day

      t.timestamps
    end

    create_table :eat_plan_categories do |t|
      t.references :category, foreign_key: true, index: false, null: false
      t.references :eat_plan, foreign_key: true, null: false

      t.timestamps

      t.index %i[category_id eat_plan_id], unique: true
    end
  end
end
