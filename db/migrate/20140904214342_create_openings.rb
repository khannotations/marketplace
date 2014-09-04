class CreateOpenings < ActiveRecord::Migration
  def change
    create_table :openings do |t|

      t.timestamps
    end
  end
end
