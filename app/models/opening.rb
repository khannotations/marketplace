class Opening < ActiveRecord::Base
  include PgSearch

  # Validations
  validates_presence_of :name, :description, :pay_amount, :pay_type, :timeframe

  # Associations
  belongs_to :project
  has_and_belongs_to_many :members, class_name: "User"
  # has_and_belongs_to_many :tags, as: :taggable
  has_many :skill_links, as: :skillable
  has_many :skills, through: :skill_links

  pg_search_scope :thorough_search,
    against: [:name, :description],
    using: {tsearch: {dictionary: "english", any_word: true}},
    associated_against: {
      project: [:name, :description]
    }

  # Search is put here, though it returns Openings and User
  # Returns all openings that match any of the query terms, or whose project
  # does, or that have a skill that matches one of the query terms
  # TODO: how to sort?
  def self.search(query, page=0)
    text_openings = thorough_search(query) # match by name, desc
    skill_openings = Skill.search(query).map(&:openings).flatten # match by skill
    # Prioritize those that match by both
    return (text_openings + skill_openings).uniq
    # Split
    # Get ones with all
    # Get ones with any
    # Uniq
  end
  # Look through all skills, get associated openings, users
  # Look through names, descriptions (of project and opening)
  # Term time
  # Salary / lumpsum
end
