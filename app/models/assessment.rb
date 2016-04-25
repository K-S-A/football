class Assessment < ActiveRecord::Base
  belongs_to :user
  belongs_to :rated_user, class_name: 'User'
  belongs_to :tournament

  validates :user, presence: true
  validates :rated_user, presence: true
  validates :score, presence: true,
                    uniqueness: { scope: [:user_id, :tournament_id] }
end
