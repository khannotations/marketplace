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

      t.string :github_url
      t.string :linkedin_url
      t.string :personal_site
      t.text :bio
      t.text :past_experiences

      t.attachment :resume
      t.attachment :picture

      t.boolean :has_logged_in, default: false
      t.boolean :show_in_results, default: true
      t.boolean :send_digest, default: true

      t.timestamps
    end
  end
end
