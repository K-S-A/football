class Match < ActiveRecord::Base
  belongs_to :round
  belongs_to :host_team, class_name: 'Team'
  belongs_to :guest_team, class_name: 'Team'

  validates :guest_score, numericality: { greater_than_or_equal_to: 0,
                                          allow_blank: true }
  validates :host_score, numericality: { greater_than_or_equal_to: 0,
                                         allow_blank: true }
end
