class Team < ActiveRecord::Base
  has_and_belongs_to_many :users

  def matches
    Match.where('host_team_id = :team_id OR guest_team_id = :team_id', team_id: self.id)
  end
end
