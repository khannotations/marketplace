class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :photo_url
      t.boolean :approved, default: false

      t.timestamps
    end

    create_join_table :users, :projects # Leaders
  end
end
