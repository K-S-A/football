class Team < ActiveRecord::Base
  include RankedModel

  belongs_to :tournament
  has_and_belongs_to_many :users
  has_and_belongs_to_many :rounds

  after_destroy { matches.destroy_all }

  validates :name, presence: true,
                   length: { minimum: 3 },
                   uniqueness: { case_sensitive: false, scope: :tournament_id }

  ranks :list_order, with_same: :tournament_id
  default_scope { rank(:list_order) }

  def matches
    Match.where('host_team_id = :id OR guest_team_id = :id', id: id)
  end
end
