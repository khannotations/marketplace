class Opening < ActiveRecord::Base
  include PgSearch

  # Validations
  validates_presence_of :name, :description, :pay_amount, :pay_type,
    :timeframe, :project_id

  # Callbacks
  before_create :set_expires

  # Associations
  belongs_to :project
  has_and_belongs_to_many :members, class_name: "User"
  has_many :skill_links, as: :skillable, dependent: :destroy
  has_many :skills, through: :skill_links

  has_many :favorites, dependent: :destroy
  has_many :favoriting_users, through: :favorites,
    class_name: "User", source: :user
    
  # Scopes
  default_scope {includes([:skills, :project])}

  # Constants
  PAY_TYPE_HOURLY = "hourly"
  PAY_TYPE_LUMPSUM = "lumpsum"
  PAY_TYPE_VOLUNTEER = "volunteer"
  TIMEFRAME_TERM = "termtime"
  TIMEFRAME_SUMMER = "summer"
  TIMEFRAME_FULL = "fulltime"

  pg_search_scope :thorough_search,
    against: [:name, :description],
    using: {tsearch: {dictionary: "english", any_word: true}}

  def expired?
    return expires_on <= Date.now
  end

  # Given an array of openings, returns those that are OK to show in search
  # results
  def self.search_filtered(openings)
    openings.select { |o| o.project.approved && !o.expire_notified && !o.filled}
  end

  # Search is put here, though it returns Openings and User
  # Returns all openings that match any of the query terms, or whose project
  # does, or that have a skill that matches one of the query terms
  # @param query Hash A "search object", that has the following keys:
  #   q: the search query
  def self.search(search_params, page=0)
    page ||= 0
    query = search_params[:q]
    # TODO: how to match everything? Does postgres search do globbing? ie. *
    matching_openings = thorough_search(query) # match by name, desc
    project_openings = Project.thorough_search(query).map(&:openings).flatten
    skill_openings = Skill.search(query).map(&:openings).flatten
    all = (matching_openings + project_openings + skill_openings).uniq
    return Opening.search_filtered all
  end

  def self.notify_expired
    expired_openings = Opening.includes(project: :leaders)
      .where("expires_on <= ?", Date.today)
      .where(expire_notified: false)
    expired_openings.each do |o|
        ProjectMailer.expired_opening(o).deliver
        o.expire_notified = true
        o.save
    end
  end

  def serializable_hash(options={})
    options = {
      :include => [:skills, :project]
    }.update(options)
    super(options)
  end

  private

  def set_expires
    self.expires_on = Date.today + 1.month
  end
end
