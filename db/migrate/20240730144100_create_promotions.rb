class CreatePromotions < ActiveRecord::Migration[7.0]
  def change
    create_table :promotions do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.integer :bonus_amount

      t.timestamps
    end
  end
end
