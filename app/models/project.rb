class Project < ActiveRecord::Base
  include PgSearch
  has_and_belongs_to_many :leaders, class_name: "User", source: :leader_projects
  has_many :openings, dependent: :destroy
  has_many :members, through: :openings, class_name: "User"

  validates_presence_of :name, :description

  # Scopes
  default_scope { includes(:openings, :leaders) }
  pg_search_scope :thorough_search,
    against: [:name, :description],
    using: {tsearch: {dictionary: "english", any_word: true}}

  def serializable_hash(options={})
    options = { 
      :include => [:openings, :leaders]
    }.update(options)
    super(options)
  end
end
