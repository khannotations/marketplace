class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.text :description
      t.string :photo_url

      t.timestamps
    end

    create_join_table :users, :projects
  end
end