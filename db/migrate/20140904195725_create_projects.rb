class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :photo_url

      t.string :timeframe
      t.integer :pay_amount
      t.string :pay_type
      t.integer :num_slots

      t.date :expires_on
      t.boolean :expire_notified, default: false
      t.boolean :filled, default: false
      t.boolean :approved, default: false

      t.timestamps
    end

    create_join_table :users, :projects # Leaders
  end
end
