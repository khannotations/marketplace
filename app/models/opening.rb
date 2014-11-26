class Opening < ActiveRecord::Base
  include PgSearch

  # Validations
  validates_presence_of :name, :description, :pay_amount, :pay_type,
    :timeframe, :project_id

  # Associations
  belongs_to :project
  has_and_belongs_to_many :members, class_name: "User"
  has_many :skill_links, as: :skillable, dependent: :destroy
  has_many :skills, through: :skill_links

  has_many :favorites, dependent: :destroy
  has_many :favoriting_users, through: :favorites,
    class_name: "User", source: :user
    
  # Scopes
  default_scope {includes(:skills)}

  # Constants
  PAY_TYPE_HOURLY = "hourly"
  PAY_TYPE_LUMPSUM = "lumpsum"
  PAY_TYPE_VOLUNTEER = "volunteer"
  TIMEFRAME_TERM = "termtime"
  TIMEFRAME_SUMMER = "summer"
  TIMEFRAME_FULL = "full time"

  pg_search_scope :thorough_search,
    against: [:name, :description],
    using: {tsearch: {dictionary: "english", any_word: true}}

  # Search is put here, though it returns Openings and User
  # Returns all openings that match any of the query terms, or whose project
  # does, or that have a skill that matches one of the query terms
  # @param query Hash A "search object", that has the following keys:
  #   q: the search query
  #   timeframe: an array of valid timeframes
  #   pay_gauge: an array of "pay gauges"
  #     pay gauge 0: volunteer work
  #     pay gauge 1: Less than $10/hour or $500
  #     pay gauge 2: Less than $20/hour or $1500
  #     pay gauge 3: More than that
  # TODO: how to sort?
  # TODO: eager load
  def self.search(search_params, page=0)
    page ||= 0
    query = search_params[:q]
    # TODO: how to match everything? Does postgres search do globbing? ie. *
    matching_openings = thorough_search(query) # match by name, desc
    project_openings = Project.thorough_search(query).map(&:openings).flatten
    skill_openings = Skill.search(query).map(&:openings).flatten
    # TODO:Prioritize those that match by both
    return (matching_openings + project_openings + skill_openings).uniq
  end

  def serializable_hash(options={})
    options = {
      :include => :skills
    }.update(options)
    super(options)
  end
end
