class Opening < ActiveRecord::Base
  belongs_to :project
  has_and_belongs_to_many :members, class_name: "User"
  has_and_belongs_to_many :tags, as: :taggable
end
