class Project < ActiveRecord::Base
  has_and_belongs_to_many :leaders, class_name: "User"
  has_many :openings
  has_many :members, through: :openings, class_name: "User"
  has_and_belongs_to_many :tags, as: :taggable
end
