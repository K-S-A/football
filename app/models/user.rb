class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :tournaments
  has_many :assessments

  def short_name
    "#{first_name} #{last_name.first}."
  end

  def unrated_tournaments
    Tournament.find_by_sql(unrated_tournaments_query(id))
  end

  private

  def unrated_tournaments_query(user_id)
    %(SELECT DISTINCT tournaments.*
    FROM tournaments
      LEFT JOIN assessments
      ON tournaments.id = assessments.tournament_id AND assessments.user_id = #{user_id}
    WHERE assessments.id IS NULL AND tournaments.status = 'completed')
  end
end
