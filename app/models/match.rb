class Match < ActiveRecord::Base
  belongs_to :round
  belongs_to :host_team, class_name: 'Team'
  belongs_to :guest_team, class_name: 'Team'

  class << self
    def batch_generate(team_ids, round_id, games_count = 1)
      transaction do
        team_ids.each.with_index(1).with_object([]) do |(t1, index), arr|
          team_ids[index..-1].each do |t2|
            games_count.times do |i|
              host_team_id, guest_team_id = i.odd? ? [t1, t2] : [t2, t1]

              arr << create(round_id: round_id,
                            host_team_id: host_team_id,
                            guest_team_id: guest_team_id)
            end
          end
        end
      end
    end
  end
end
