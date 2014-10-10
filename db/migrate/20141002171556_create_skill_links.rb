class CreateSkillLinks < ActiveRecord::Migration
  def change
    create_table :skill_links do |t|
      t.belongs_to :skill
      t.belongs_to :skillable, polymorphic: true
      t.timestamps
    end
  end
end
