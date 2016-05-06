class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook, :vkontakte]

  has_and_belongs_to_many :teams
  has_and_belongs_to_many :tournaments
  has_many :assessments

  def short_name
    "#{first_name} #{last_name.first}."
  end

  def unrated_tournaments
    Tournament.find_by_sql(unrated_tournaments_query(id))
  end

  class << self
    def from_omniauth(auth)
      # Prevents NoMethodError (auth == nil):
      # in case if user revoces access when redirected to omniauth provider
      return unless auth

      where(email: auth.info.email).first_or_create do |user|
        user.password = Devise.friendly_token[0, 20]
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
        user.img_link = auth.info.image
      end
    end
  end

  private

  def unrated_tournaments_query(user_id)
    # TODO: fix selection of tournaments that not connected to user.
    %(SELECT DISTINCT tournaments.*
    FROM tournaments
      LEFT JOIN assessments
      ON tournaments.id = assessments.tournament_id AND assessments.user_id = #{user_id}
    WHERE assessments.id IS NULL AND tournaments.status = 'completed')
  end
end
