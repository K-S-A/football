class User < ActiveRecord::Base
  RANK_CORRELATION = 1000

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

  def update_rank_from(tournament)
    max_score = tournament.users.count
    score = tournament.assessments.where(rated_user_id: id).average(:score)

    return unless score
    self.rank = (1 - score / max_score) * RANK_CORRELATION
    save
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
end
