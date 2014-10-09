class Project < ActiveRecord::Base
  include PgSearch
  has_and_belongs_to_many :leaders, class_name: "User"
  has_many :openings, dependent: :destroy
  has_many :members, through: :openings, class_name: "User"
  # has_and_belongs_to_many :tags, as: :taggable

  validates_presence_of :name, :description

  pg_search_scope :thorough_search,
    against: [:name, :description],
    using: {tsearch: {dictionary: "english", any_word: true}}
end
