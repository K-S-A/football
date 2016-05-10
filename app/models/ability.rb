class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    case
    when user.admin?
      can :manage, :all
    when user.persisted?
      can :update, Tournament
      can :create, Assessment
      can :read, :all
      cannot :index, User
      can :index_teams, :all
      can :join, Tournament
    else
      can :read, :all
      cannot :index, User
      can :index_teams, :all
      cannot :join, Tournament
    end
  end
end
