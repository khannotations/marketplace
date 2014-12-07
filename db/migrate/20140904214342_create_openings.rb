class CreateOpenings < ActiveRecord::Migration
  def change
    create_table :openings do |t|
      t.belongs_to :project
      t.string :name
      t.string :description
      t.string :timeframe
      t.integer :pay_amount
      t.string :pay_type
      t.integer :num_slots

      t.date :expires_on
      t.boolean :expire_notified, default: false
      t.boolean :filled, default: false

      t.timestamps
    end
    create_join_table :users, :openings
  end
end
