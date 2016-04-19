class Round < ActiveRecord::Base
  belongs_to :tournament
  has_many :matches
  has_and_belongs_to_many :teams, after_remove: :destroy_matches

  def destroy_matches(team)
    matches.where('host_team_id = :id OR guest_team_id = :id', id: team.id).destroy_all
  end
end
