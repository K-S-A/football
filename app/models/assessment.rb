class Assessment < ActiveRecord::Base
  belongs_to :user
  belongs_to :tournament

  validates :user, presence: true
end
