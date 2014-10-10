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
    using: {tsearch: {dictionary: "english", any_word: true}}

  # Search is put here, though it returns Openings and User
  # Returns all openings that match any of the query terms, or whose project
  # does, or that have a skill that matches one of the query terms
  # TODO: how to sort?
  # TODO: eager load
  def self.search(query, page=0)
    matching_openings = thorough_search(query) # match by name, desc
    project_openings = Project.thorough_search(query).map(&:openings).flatten
    skill_openings = Skill.search(query).map(&:openings).flatten
    # TODO:Prioritize those that match by both
    return (matching_openings + project_openings + skill_openings).uniq
  end
  # TODO: Term time
  # TODO: Salary / lumpsum
end
