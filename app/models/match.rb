class Match < ActiveRecord::Base
  belongs_to :round
  belongs_to :host_team, class_name: 'Team'
  belongs_to :guest_team, class_name: 'Team'

  class << self
    def batch_generate(team_ids, round_id, games_count = 1)
      matches = []

      ActiveRecord::Base.transaction do
        team_ids.each do |t1|
          team_ids.each do |t2|
            next if t1 == t2

            games_count.times do |i|
              host_team_id, guest_team_id = i.odd? ? [t1, t2] : [t2, t1]

              matches << create(round_id: round_id,
                                host_team_id: host_team_id,
                                guest_team_id: guest_team_id)
            end
          end
        end
      end

      matches
    end
  end
end
