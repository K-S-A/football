class Tournament < ActiveRecord::Base
  has_many :rounds
  has_many :teams
  has_many :assessments
  has_and_belongs_to_many :users
end
