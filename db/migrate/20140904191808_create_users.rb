class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :netid
      t.string :email
      t.string :year
      t.string :college
      t.string :division # Yale section
      t.string :title # For professors
      t.boolean :is_admin, default: false
      t.string :photo_url

      t.string :short_bio
      t.text :bio
      t.text :past_experiences

      # Resume, past experiences => v0
      # Link to LinkedIn => v1
      # Skills => v1

      t.timestamps
    end
  end
end
