class Team < ActiveRecord::Base
  belongs_to :tournament
  has_and_belongs_to_many :users
  has_and_belongs_to_many :rounds

  after_destroy { matches.destroy_all }

  def matches
    Match.where('host_team_id = :id OR guest_team_id = :id', id: id)
  end
end
