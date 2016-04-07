class Tournament < ActiveRecord::Base
  # belongs_to :user
  has_many :rounds
  has_many :teams
  has_and_belongs_to_many :users
end
