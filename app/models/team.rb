class Team < ActiveRecord::Base
  belongs_to :tournament
  has_and_belongs_to_many :users
  has_and_belongs_to_many :rounds

  after_destroy { matches.destroy_all }

  validates :name, presence: true,
                   length: { minimum: 3 },
                   uniqueness: { case_sensitive: false, scope: :tournament_id }

  def matches
    Match.where('host_team_id = :id OR guest_team_id = :id', id: id)
  end
end
