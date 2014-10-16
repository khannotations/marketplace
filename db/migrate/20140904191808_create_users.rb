class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :netid, index: true
      t.string :email
      t.string :year
      t.string :college
      t.string :division # Yale section
      t.string :title # For professors
      t.boolean :is_admin, default: false
      t.string :photo_url

      t.string :github_url
      t.string :linkedin_url
      t.text :bio
      t.text :past_experiences

      t.attachment :resume

      t.timestamps
    end
  end
end
