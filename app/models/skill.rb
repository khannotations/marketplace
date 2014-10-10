class Skill < ActiveRecord::Base
  include PgSearch

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :skill_links, dependent: :destroy
  has_many :users, through: :skill_links,
    source: :skillable, source_type: "User"
  has_many :openings, through: :skill_links,
    source: :skillable, source_type: "Opening"

  pg_search_scope :search, against: :name
end
