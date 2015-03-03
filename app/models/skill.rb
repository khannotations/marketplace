class Skill < ActiveRecord::Base
  include PgSearch

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :skill_links, dependent: :destroy
  has_many :users, through: :skill_links,
    source: :skillable, source_type: "User"
  has_many :projects, through: :skill_links,
    source: :skillable, source_type: "Project"

  pg_search_scope :search, against: :name

  def serializable_hash(options={})
    options = {
      :except => [:created_at, :updated_at]
    }.update(options)
    super(options)
  end
end
