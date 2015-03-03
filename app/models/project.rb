class Project < ActiveRecord::Base
  include PgSearch

  # Validations
  validates_presence_of :name, :description, :pay_amount, :pay_type,
    :timeframe

  # Callbacks
  before_create :set_expires

  # Associations
  has_and_belongs_to_many :leaders, class_name: "User", source: :leader_projects
  has_and_belongs_to_many :members, class_name: "User"
  has_many :skill_links, as: :skillable, dependent: :destroy
  has_many :skills, through: :skill_links

  has_many :favorites, dependent: :destroy
  has_many :favoriting_users, through: :favorites,
    class_name: "User", source: :user
    
  # Scopes
  default_scope {includes([:skills, :leaders])}

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

  def favorite_count
    return favorite_ids.count
  end

  def error_string
    self.errors.full_messages.join("<br>")
  end

  # Given an array of projects, returns those that are OK to show in search
  # results
  def self.search_filtered(projects)
    projects.select { |p| p.approved && !p.expire_notified && !p.filled}.uniq
  end

  # Returns all projects that match any of the query terms, or whose project
  # does, or that have a skill that matches one of the query terms
  # @param query Hash A "search object", that has the following keys:
  #   q: the search query
  def self.search(search_params, page=0)
    page ||= 0
    query = search_params[:q]
    # TODO: how to match everything? Does postgres search do globbing? ie. *
    matching_projects = thorough_search(query) # match by name, desc
    skill_projects = Skill.search(query).map(&:projects).flatten
    all = (matching_projects + skill_projects)
    return Project.search_filtered all
  end

  def self.notify_expired
    expired_projects = Project.includes(:leaders)
      .where("expires_on <= ?", Date.today)
      .where(expire_notified: false)
    expired_projects.each do |p|
        ProjectMailer.expired(p).deliver
        p.expire_notified = true
        p.save
    end
  end

  def serializable_hash(options={})
    options = {
      :include => [:skills, :leaders],
      :methods => [:favorite_count]
    }.update(options)
    super(options)
  end

  private

  def set_expires
    self.expires_on = Date.today + 1.month
  end
end
